//
//  MessageTextCell.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import UIKit

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
    
    open lazy var messageLabel: ActiveLabel = {
        let label = ActiveLabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Properties
    open var message: Message? {
        didSet {
            if let message = self.message {

                self.avatarImageView.image = message.sender.image
                
                if let actions = message.actions {
                    var types = self.messageLabel.enabledTypes
                    for (key, value) in actions {
                        let customType = ActiveType.custom(pattern: key)

                        self.messageLabel.customColor[customType] = UIColor.purple
                        self.messageLabel.customSelectedColor[customType] = UIColor.green
                        
                        self.messageLabel.handleCustomTap(for: customType) { element in
                            print("\(element): \(value) tapped")
                        }
                        types.append(customType)
                    }
                    self.messageLabel.enabledTypes = types
                }
                
               self.messageLabel.text = message.text
            }
        }
    }
    
    var layoutAttributes: MessageCellLayoutAttributes? {
        didSet {
            if let _ = layoutAttributes {
                self.layoutSubviews()
            }
        }
    }
    
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.bubbleImageView)
        self.bubbleImageView.addSubview(self.messageLabel)
    
        self.contentView.addSubview(self.avatarImageView)
        
        if let path = Bundle.imagePath(for: "bubble_out@2x") {
            self.bubbleImageView.image = UIImage.init(contentsOfFile: path)?.stretch()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let attributes = self.layoutAttributes {
            self.bubbleImageView.frame = attributes.messageContainerFrame
            self.messageLabel.frame = CGRect.init(x: attributes.messageLabelInsets.left, y: attributes.messageLabelInsets.top, width: attributes.messageContainerFrame.width - attributes.messageLabelInsets.left - attributes.messageLabelInsets.right, height: attributes.messageContainerFrame.height - attributes.messageLabelInsets.top - attributes.messageLabelInsets.bottom)
            self.avatarImageView.frame = attributes.avatarFrame
            self.avatarImageView.layer.cornerRadius = attributes.avatarFrame.width / 2

        }
    }
}


