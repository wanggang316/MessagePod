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
    
    open lazy var messageLabel: ActiveLabel = {
        let label = ActiveLabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
//        label.enabledTypes = [.mention, .hashtag, .url]
//        label.handleHashtagTap { hashtag in
//            print("Success. You just tapped the \(hashtag) hashtag")
//        }
//        label.handleURLTap({ url in
//            UIApplication.shared.openURL(url)
//        })
//        label.handleMentionTap { userHandle in
//            print("\(userHandle) tapped")
//        }
        return label
    }()
    
    // MARK: - Properties
    open var message: Message? {
        didSet {
            if let message = self.message {
//                self.messageTextView.attributedText = message.attributeText
               
                
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
    
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.bubbleImageView)
        self.bubbleImageView.addSubview(self.messageLabel)
    
        if let path = Bundle.imagePath(for: "bubble_out@2x") {
            self.bubbleImageView.image = UIImage.init(contentsOfFile: path)?.stretch()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.bubbleImageView.frame = CGRect.init(x: 15, y: 10, width: 240, height: self.frame.height - 20)
        self.messageLabel.frame = CGRect.init(x: 5, y: 5, width: self.bubbleImageView.frame.width - 10, height: self.bubbleImageView.frame.height - 10)
    }
    
}

//extension MessageTextCell: UITextViewDelegate {
//    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        return true
//    }
//}

