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
    
    open lazy var messageLabel: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.displaysAsynchronously = true
        return label
    }()

    var textInsets: UIEdgeInsets = .zero
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
//            textInsets = attributes.messageLabelInsets
            messageLabel.textContainerInset = attributes.messageLabelInsets
//            messageLabel.font = attributes.messageLabelFont
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
      
//        messageLabel.attributedText = nil
//        messageLabel.text = nil
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(messageLabel)
        setupConstraints()
    }
    
    open func setupConstraints() {
        messageLabel.fillSuperview()
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
