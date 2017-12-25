//
//  AvatarView.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

public class AvatarView: UIView {

    open var avatar: Avatar = Avatar()
    
    open var imageView = UIImageView()
    
    public var image: UIImage? {
        return imageView.image
    }
    
    private var radius: CGFloat?


    // MARK: - Overridden Properties
    open override var frame: CGRect {
        didSet {
            imageView.frame = bounds
            setCorner(radius: self.radius)
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            imageView.frame = bounds
            setCorner(radius: self.radius)
        }
    }
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    internal func prepareView() {
        backgroundColor = .gray
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = frame
        addSubview(imageView)
        imageView.image = avatar.image
        setCorner(radius: nil)
    }
    
    // MARK: - Open setters
    
    open func set(avatar: Avatar) {
        imageView.image = avatar.image
    }
    
    open func setCorner(radius: CGFloat?) {
        guard let radius = radius else {
            //if corner radius not set default to Circle
            let cornerRadius = min(frame.width, frame.height)
            layer.cornerRadius = cornerRadius/2
            return
        }
        self.radius = radius
        layer.cornerRadius = radius
    }
}
