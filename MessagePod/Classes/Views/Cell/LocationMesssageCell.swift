//
//  LocationMesssageCell.swift
//  MessagePod
//
//  Created by gang wang on 27/12/2017.
//

import Foundation
import MapKit

open class LocationMesssageCell: MessageCollectionViewCell {
    
    open override class func reuseIdentifier() -> String {
        return "com.messagepod.cell.location"
    }
    
    open var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    open var imageView = UIImageView()
    open var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 95.0 / 255.0, green: 95.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    open override func setupSubviews() {
        super.setupSubviews()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(addressLabel)
        messageContainerView.addSubview(activityIndicator)
        setupConstraints()
    }
    
    open func setupConstraints() {
        imageView.addConstraints(messageContainerView.topAnchor, left: messageContainerView.leftAnchor, right: messageContainerView.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 120)
        addressLabel.addConstraints(imageView.bottomAnchor, left: messageContainerView.leftAnchor, right: messageContainerView.rightAnchor, topConstant: 4, leftConstant: 12, rightConstant: 6)
        activityIndicator.centerInSuperview()
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate is not set.")
        }
        
        let options = displayDelegate.snapshotOptionsForLocation(message: message, at: indexPath, in: messagesCollectionView)
        let annotationView = displayDelegate.annotationViewForLocation(message: message, at: indexPath, in: messagesCollectionView)
        let animationBlock = displayDelegate.animationBlockForLocation(message: message, at: indexPath, in: messagesCollectionView)
        
        guard case let .location(title, address, location) = message.data else { fatalError("") }

        addressLabel.text = address
        
        if self.imageView.image == nil {
            activityIndicator.startAnimating()
        }
        let snapshotOptions = MKMapSnapshotOptions()
        snapshotOptions.region = MKCoordinateRegion(center: location.coordinate, span: options.span)
        snapshotOptions.showsBuildings = options.showsBuildings

        let snapShotter = MKMapSnapshotter(options: snapshotOptions)

        snapShotter.start { (snapshot, error) in
            defer {
                self.activityIndicator.stopAnimating()
            }
            guard let snapshot = snapshot, error == nil else {
                //show an error image?
                return
            }
            
            guard let annotationView = annotationView else {
                self.imageView.image = snapshot.image
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(snapshotOptions.size, true, 0)
            
            snapshot.image.draw(at: .zero)
            
            var point = snapshot.point(for: location.coordinate)
            //Move point to reflect annotation anchor
            point.x -= annotationView.bounds.size.width / 2
            point.y -= annotationView.bounds.size.height / 2
            point.x += annotationView.centerOffset.x
            point.y += annotationView.centerOffset.y
            
            annotationView.image?.draw(at: point)
            let composedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            self.imageView.image = composedImage
            animationBlock?(self.imageView)
        }


    }
    
}
