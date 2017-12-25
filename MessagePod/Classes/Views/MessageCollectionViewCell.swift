//
//  MessageCollectionViewCell.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessageCollectionViewCell: UICollectionViewCell, CollectionViewReusable {
    
    open class func reuseIdentifier() -> String {
        return "com.messagepod.cell.base"
    }
    
    open var avatarView = AvatarView()

    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    open var cellTopLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    open var cellBottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    open weak var delegate: MessageCellDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
//        setupGestureRecognizers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews() {
        contentView.addSubview(messageContainerView)
        contentView.addSubview(avatarView)
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(cellBottomLabel)
    }
    
    open override func prepareForReuse() {
        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellBottomLabel.text = nil
        cellBottomLabel.attributedText = nil
    }
    
    // MARK: - Configuration
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            avatarView.frame = attributes.avatarFrame
            cellTopLabel.frame = attributes.topLabelFrame
            cellBottomLabel.frame = attributes.bottomLabelFrame
            messageContainerView.frame = attributes.messageContainerFrame
        }
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource is not set.")
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate is not set.")
        }
        
        delegate = messagesCollectionView.messageCellDelegate
        
//        let messageColor = displayDelegate.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)
        let messageStyle = displayDelegate.messageStyle(for: message, at: indexPath, in: messagesCollectionView)
        
//        messageContainerView.backgroundColor = messageColor
        messageContainerView.style = messageStyle
        
        let avatar = Avatar.init(image: message.sender.image, initials: message.sender.name)// dataSource.avatar(for: message, at: indexPath, in: messagesCollectionView)
        let topText = dataSource.cellTopLabelText(for: message, at: indexPath)
        let bottomText = dataSource.cellBottomLabelText(for: message, at: indexPath)
        
        avatarView.set(avatar: avatar)
        cellTopLabel.text = topText
        cellBottomLabel.text = bottomText
    }
    
//    func setupGestureRecognizers() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        contentView.addGestureRecognizer(tapGesture)
//    }
//
//    /// Handle tap gesture on contentView and its subviews like messageContainerView, cellTopLabel, cellBottomLabel, avatarView ....
//    @objc
//    open func handleTapGesture(_ gesture: UIGestureRecognizer) {
//        guard gesture.state == .ended else { return }
//
//        let touchLocation = gesture.location(in: self)
//
//        switch true {
//        case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
//            delegate?.didTapMessage(in: self)
//        case avatarView.frame.contains(touchLocation):
//            delegate?.didTapAvatar(in: self)
//        case cellTopLabel.frame.contains(touchLocation):
//            delegate?.didTapTopLabel(in: self)
//        case cellBottomLabel.frame.contains(touchLocation):
//            delegate?.didTapBottomLabel(in: self)
//        default:
//            break
//        }
//    }
//
//    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
//        return false
//    }
}
