//
//  MessageDateHeaderView.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessageDateHeaderView: MessageHeaderView {
    
    open override class func reuseIdentifier() -> String {
        return "com.messagepod.header.date"
    }

    // MARK: - Properties
    
    open let dateLabel = UILabel()
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        dateLabel.fillSuperview()
        dateLabel.textAlignment = .center
        dateLabel.font = .boldSystemFont(ofSize: 10)
        dateLabel.textColor = .darkGray
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
