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
    
    init(message: Message, indexPath: IndexPath, avatarPosition: AvatarPosition) {
        self.avatarPosition = avatarPosition
        self.message = message
        self.indexPath = indexPath
    }
    
    // Cell
    var itemHeight: CGFloat = 0
    var itemWidth: CGFloat = UIScreen.main.bounds.width

    
    // avatar
    var avatarPosition: AvatarPosition// = AvatarPosition.init(side: .cellLeading, margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
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
        
        var origin: CGPoint
        switch avatarPosition.side {
        case .cellLeading:
            origin = CGPoint.init(x: avatarPosition.margin.left, y: avatarPosition.margin.top)
        case .cellTrailing:
            origin = CGPoint.init(x: itemWidth - avatarPosition.margin.right - avatarSize.width, y: avatarPosition.margin.top)
        }
        return CGRect(origin: origin, size: avatarSize)
    }()
    
    
    lazy var messageContainerFrame: CGRect = {
        
        guard messageContainerSize != .zero else { return .zero }
        
        var origin: CGPoint = .zero
        
        switch avatarPosition.side {
        case .cellLeading:
            origin = CGPoint.init(x: avatarPosition.margin.left + avatarSize.width + messageContainerPadding.left, y: messageContainerPadding.top)
        case .cellTrailing:
            origin = CGPoint.init(x: avatarFrame.origin.x - messageContainerPadding.right - messageContainerSize.width, y: messageContainerPadding.top)
        }
        
        return CGRect(origin: origin, size: messageContainerSize)
    }()
    
    
    // avatar
    var avatarHorizontalInset: CGFloat {
        switch avatarPosition.side {
        case .cellLeading:
            return avatarPosition.margin.left
        case .cellTrailing:
            return avatarPosition.margin.right
        }
    }
    
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
