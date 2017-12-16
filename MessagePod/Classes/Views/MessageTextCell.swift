//
//  MessageTextCell.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import UIKit

open class MessageTextCell: UITableViewCell {

    open var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.bubbleImageView)
        
        self.bubbleImageView.frame = CGRect.init(x: 0, y: 0, width: 200, height: 50)
        
        let assetBundle = Bundle.messagePodBundle()
        if let imagePath = assetBundle.path(forResource: "bubble_out", ofType: "png", inDirectory: "images") {
            self.bubbleImageView.image = UIImage.init(contentsOfFile: imagePath)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
