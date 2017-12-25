//
//  TextMessageCell.swift
//  MessagePod
//
//  Created by gang wang on 26/12/2017.
//

import UIKit
import YYText

open class TextMessageCell: MessageCollectionViewCell {

    open override class func reuseIdentifier() -> String {
        return "com.messagepod.cell.text"
    }

    open override weak var delegate: MessageCellDelegate? {
        didSet {
//            messageLabel.delegate = delegate
        }
    }
    
    open var messageLabel = YYLabel()

    var textInsets: UIEdgeInsets = .zero
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            textInsets = attributes.messageLabelInsets
            messageLabel.font = attributes.messageLabelFont
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.numberOfLines = 0
        messageLabel.isUserInteractionEnabled = true
        messageLabel.displaysAsynchronously = true
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(messageLabel)
        setupConstraints()
    }
    
    open func setupConstraints() {
        messageLabel.addConstraints(messageContainerView.topAnchor, left: messageContainerView.leftAnchor, bottom: messageContainerView.bottomAnchor, right: messageContainerView.rightAnchor, topConstant: textInsets.top, leftConstant: textInsets.left, bottomConstant: textInsets.bottom, rightConstant: textInsets.right)
    }

    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate not set.")
        }
        
        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        self.messageLabel.textColor = textColor
        
        switch message.data {
        case .text(let text, let actions):
            if let actions = actions {
                
                let attributedString = NSMutableAttributedString.init(string: text)
                
                attributedString.yy_font = UIFont.systemFont(ofSize: 14)
                let hightLight = YYTextHighlight()
                hightLight.setColor(UIColor.red)
                hightLight.tapAction = { (view, attributeString, range, rect) in
                    guard let r = Range(range, in: attributedString.string) else { return }
                    let key = attributedString.string[r]
                    let keyString = String(key)
                    print("-----> \(String(describing: actions[keyString]))")
                }
                
                for (key, _) in actions {
                    if let range = text.range(of: key) {
                        let nsrange = NSRange.init(range, in: text)
                        attributedString.yy_setTextHighlight(hightLight, range: nsrange)
                        attributedString.yy_setColor(UIColor.red, range: nsrange)
                        attributedString.yy_setTextUnderline(YYTextDecoration.init(style: YYTextLineStyle.single), range: nsrange)
                    }
                }
                self.messageLabel.attributedText = attributedString
            } else {
                self.messageLabel.text = text
            }
        default:
            break
        }
    }
}
