//
//  MessageTextCell.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import UIKit

open class MessageTextCell: UITableViewCell {

    open lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    open var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.bubbleImageView)
    
        if let path = Bundle.imagePath(for: "bubble_out@2x") {
            self.bubbleImageView.image = UIImage.init(contentsOfFile: path)?.stretch()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.bubbleImageView.frame = CGRect.init(x: 15, y: 5, width: 240, height: self.frame.height - 10)

        self.textView.frame = CGRect.init(x: 15, y: 5, width: 240, height: self.frame.height - 10)
    }
    
}