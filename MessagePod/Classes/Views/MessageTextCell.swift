//
//  MessageTextCell.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import UIKit
//import TTTAttributedLabel
import YYText

open class MessageTextCell: UITableViewCell {

    // MARK: - UI Elements
    
    open lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
//    open lazy var messageTextView: UITextView = {
//        let textView = UITextView()
//        textView.delegate = self
//        textView.font = UIFont.systemFont(ofSize: 14)
//        textView.textColor = UIColor.darkGray
//        textView.backgroundColor = UIColor.white
//        textView.textContainerInset = UIEdgeInsets.zero
//        textView.dataDetectorTypes = .all
//        textView.isUserInteractionEnabled = true
//        textView.isSelectable = true
//        textView.isEditable = false
//        return textView
//    }()
    
    open lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
//    open lazy var messageLabel: TTTAttributedLabel = {
//        let label = TTTAttributedLabel.init(frame: CGRect.zero)
//        label.delegate = self
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .black
//
//        label.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
//        label.activeLinkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
//        label.inactiveLinkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.orange]
//
//        label.enabledTextCheckingTypes = NSTextCheckingAllTypes
//        label.isUserInteractionEnabled = true
//        label.extendsLinkTouchArea = false
//        return label
//    }()
    open lazy var messageLabel: YYLabel = {
        let label = YYLabel.init(frame: CGRect.zero)
//        label.delegate = self
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        
//        label.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
//        label.activeLinkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
//        label.inactiveLinkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.orange]
//
//        label.enabledTextCheckingTypes = NSTextCheckingAllTypes
        label.isUserInteractionEnabled = true
//        label.extendsLinkTouchArea = false
        label.displaysAsynchronously = true
        return label
    }()
    
    let attr = [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
        NSAttributedStringKey.foregroundColor: UIColor.black
    ]
    // MARK: - Properties
    open var message: Message? {
        didSet {
            if let message = self.message {

                self.avatarImageView.image = message.sender.image

//                if let actions = message.actions {
//                    messageLabel.attributedText = nil
//                    let contentAttributedString = NSAttributedString.init(string: message.text, attributes: attr)
//                    self.messageLabel.attributedText = contentAttributedString
//
//                    for (key, value) in actions {
//                        if let range = message.text.range(of: key) {
//                            let nsrange = NSRange.init(range, in: message.text)
//                            messageLabel.addLink(to: URL.init(string: value)!, with: nsrange)
//                        }
//                    }
//                } else {
//                    messageLabel.attributedText = nil
//                    self.messageLabel.text = message.text
//                }
                
                if let actions = message.actions {
                
                    let attributedString = NSMutableAttributedString.init(string: message.text)
                    
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
                        if let range = message.text.range(of: key) {
                            let nsrange = NSRange.init(range, in: message.text)
                            attributedString.yy_setTextHighlight(hightLight, range: nsrange)
                            attributedString.yy_setColor(UIColor.red, range: nsrange)
                            attributedString.yy_setTextUnderline(YYTextDecoration.init(style: YYTextLineStyle.single), range: nsrange)
                        }
                    }
                    
                    self.messageLabel.attributedText = attributedString

                    

                } else {
                    self.messageLabel.text = message.text
                }
                
            }
        }
    }
    
    var layoutAttributes: MessageCellLayoutAttributes?
    
    func configCell(with newMessage: Message, attributes: MessageCellLayoutAttributes, bubbleImage: UIImage) {
        if (self.message == nil) || (newMessage != self.message!) {
            self.message = newMessage
            self.layoutAttributes = attributes

            
            self.bubbleImageView.frame = attributes.messageContainerFrame
            self.messageLabel.frame = CGRect.init(x: attributes.messageLabelInsets.left, y: attributes.messageLabelInsets.top, width: attributes.messageContainerFrame.width - attributes.messageLabelInsets.left - attributes.messageLabelInsets.right, height: attributes.messageContainerFrame.height - attributes.messageLabelInsets.top - attributes.messageLabelInsets.bottom)
            self.avatarImageView.frame = attributes.avatarFrame
            self.avatarImageView.layer.cornerRadius = attributes.avatarFrame.width / 2
            
            self.bubbleImageView.image = stretch(bubbleImage) // bubbleImage.stretch().withRenderingMode(.alwaysTemplate)
        }

    }
    
    var bubbleImage: UIImage?
    
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.bubbleImageView)
        self.bubbleImageView.addSubview(self.messageLabel)
    
        self.contentView.addSubview(self.avatarImageView)

        self.backgroundColor = UIColor.init(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func stretch(_ image: UIImage) -> UIImage {
//        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        let capInsets = UIEdgeInsets(top: 24, left: 12, bottom: 6, right: 12)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }

}

//extension MessageTextCell: TTTAttributedLabelDelegate {
//    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        print("tap url: \(url)")
//    }
//}


