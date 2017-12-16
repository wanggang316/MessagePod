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
        return imageView
    }()
    
    open lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        textView.isEditable = false
        return textView
    }()
    
    // MARK: - Properties
    open var message: Message? {
        didSet {
            if let message = self.message {
                self.messageTextView.attributedText = message.attributeText
            }
        }
    }
    
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.bubbleImageView)
        self.bubbleImageView.addSubview(self.messageTextView)
    
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

        self.messageTextView.frame = CGRect.init(x: 5, y: 5, width: self.bubbleImageView.frame.width - 10, height: self.bubbleImageView.frame.height - 10)
    }
    
}
