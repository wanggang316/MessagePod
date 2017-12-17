//
//  MessageCellLayoutAttributes.swift
//  MessagePod
//
//  Created by gang wang on 17/12/2017.
//

import UIKit

final class MessageCellLayoutAttributes {

    var message: Message
    var indexPath: IndexPath
    
    init(message: Message, indexPath: IndexPath) {
        self.message = message
        self.indexPath = indexPath
    }
    
    // Cell
    var itemHeight: CGFloat = 0
    var cellFrame: CGRect = .zero

    
    // avatar
    var avatarPosition = CGPoint.zero
    var avatarSize: CGSize = CGSize.init(width: 30, height: 30)
    
    // message label
    open var messageContainerSize: CGSize = .zero
    var messageContainerMaxWidth: CGFloat = 0
    var messageContainerPadding: UIEdgeInsets = .zero
    var messageLabelInsets: UIEdgeInsets = .zero
    
    var messageLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    
    // MARK: - get properties
    
    lazy var avatarFrame: CGRect = {
        
        guard avatarSize != .zero else { return .zero }
        var origin = avatarPosition
        
        return CGRect(origin: origin, size: avatarSize)
    }()
    
    
    lazy var messageContainerFrame: CGRect = {
        
        guard messageContainerSize != .zero else { return .zero }
        
        var origin: CGPoint = .zero
        origin.y = 10// topLabelSize.height + messageContainerPadding.top + topLabelVerticalPadding
        
        origin.x = avatarSize.width + messageContainerPadding.left
        
        return CGRect(origin: origin, size: messageContainerSize)
        
    }()
    
    
    // label
    var messageLabelVerticalInsets: CGFloat {
        return messageLabelInsets.top + messageLabelInsets.bottom
    }
    
    var messageLabelHorizontalInsets: CGFloat {
        return messageLabelInsets.left + messageLabelInsets.right
    }
    
    // container
    var messageHorizontalPadding: CGFloat {
        return messageContainerPadding.left + messageContainerPadding.right
    }
    var messageVerticalPadding: CGFloat {
        return messageContainerPadding.top + messageContainerPadding.bottom
    }
    
}
