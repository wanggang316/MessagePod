//
//  MessageLayoutAttributes.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation


final class MessageLayoutAttributes {
    
    var message: MessageType
    var indexPath: IndexPath
    
    init(message: MessageType, indexPath: IndexPath) {
        self.message = message
        self.indexPath = indexPath
    }
    
    // Cell
    var itemHeight: CGFloat = 0
    var cellFrame: CGRect = .zero
    
    var avatarPosition = AvatarPosition.init(horizontal: .cellLeading, vertical: .messageCenter)
    var avatarSize: CGSize = .zero
    
    lazy var avatarFrame: CGRect = {
        guard avatarSize != .zero else { return .zero }
        
        var origin = CGPoint.zero
        
        switch avatarPosition.horizontal {
        case .cellLeading:
            break
        case .cellTrailing:
            origin.x = cellFrame.width - avatarSize.width
        case .natural:
            fatalError("AvatarPosition Horizontal.natural needs to be resolved.")
        }
        
        switch avatarPosition.vertical {
        case .cellTop:
            break
        case .cellBottom:
            origin.y = cellFrame.height - avatarSize.height
        case .messageTop:
            origin.y = messageContainerFrame.minY
        case .messageBottom:
            origin.y = messageContainerFrame.maxY - avatarSize.height
        case .messageCenter:
            origin.y = messageContainerFrame.midY - avatarSize.height / 2
        }
        
        return CGRect.init(origin: origin, size: avatarSize)
    }()
    
    
    // MessageContrainerView
    var messageContainerSize: CGSize = .zero
    var messageContainerMaxWidth: CGFloat = 0
    var messageContainerPadding: UIEdgeInsets = .zero
    var messageLabelInsets: UIEdgeInsets = .zero
    
    lazy var messageContainerFrame: CGRect = {
        guard messageContainerSize != .zero else { return .zero }
        var origin = CGPoint.zero
        
        origin.y = topLabelSize.height + topLabelVerticalPadding + messageContainerPadding.top
        
        switch avatarPosition.horizontal {
        case .cellLeading:
            origin.x = avatarSize.width + messageContainerPadding.left
        case .cellTrailing:
            origin.x = cellFrame.width - avatarSize.width - messageContainerPadding.right - messageContainerSize.width
        case .natural:
            fatalError("AvatarPosition Horizontal.natural needs to be resolved.")
        }
        return CGRect.init(origin: origin, size: messageContainerSize)
    }()
    
    
    // Cell top Label
    var topLabelAlignment: LabelAlignment = .cellLeading(.zero)
    var topLabelSize: CGSize = .zero
    var topLabelMaxWidth: CGFloat = 0
    
    lazy var topLabelFrame: CGRect = {
        guard topLabelSize != .zero else { return .zero }
        
        var origin: CGPoint = .zero
        origin.y = topLabelPadding.top
        
        switch topLabelAlignment {
        case .cellLeading:
            origin.x = topLabelPadding.left
        case .cellTrailing:
            origin.x = cellFrame.width - topLabelSize.width - topLabelPadding.right
        case .cellCenter:
            origin.x = cellFrame.width / 2 + topLabelPadding.left - topLabelPadding.right
        case .messageLeading:
            origin.x = messageContainerFrame.origin.x + topLabelPadding.left
        case .messageTrailing:
            origin.x = messageContainerFrame.maxX - topLabelSize.width - topLabelPadding.right
        }
        return CGRect.init(origin: origin, size: topLabelSize)
    }()
    
    
    // MARK: - Cell Bottom Label
    var bottomLabelAlignment: LabelAlignment = .cellTrailing(.zero)
    var bottomLabelSize: CGSize = .zero
    var bottomLabelMaxWidth: CGFloat = 0
    
    lazy var bottomLabelFrame: CGRect = {
        guard bottomLabelSize != .zero else { return .zero }
        
        var origin: CGPoint = .zero
        origin.y = messageContainerFrame.maxY + messageContainerPadding.bottom + bottomLabelPadding.top
        
        switch bottomLabelAlignment {
        case .cellLeading:
            origin.x = bottomLabelPadding.left
        case .cellTrailing:
            origin.x = cellFrame.width - bottomLabelSize.width - bottomLabelPadding.right
        case .cellCenter:
            origin.x = cellFrame.width / 2 + bottomLabelPadding.left - bottomLabelPadding.right
        case .messageLeading:
            origin.x = messageContainerFrame.origin.x + bottomLabelPadding.left
        case .messageTrailing:
            origin.x = messageContainerFrame.maxX - bottomLabelSize.width - bottomLabelPadding.right
        }
        return CGRect.init(origin: origin, size: bottomLabelSize)
    }()
    
    
    // MARK: -
    var messageHorizontalPadding: CGFloat {
        return messageContainerPadding.left + messageContainerPadding.right
    }
    var messageVerticalPadding: CGFloat {
        return messageContainerPadding.top + messageContainerPadding.bottom
    }
    
    var messageLabelHorizontalInsets: CGFloat {
        return messageLabelInsets.left + messageLabelInsets.right
    }
    
    var messageLabelVerticalInsets: CGFloat {
        return messageLabelInsets.top + messageLabelInsets.bottom
    }
    
    
    var topLabelPadding: UIEdgeInsets {
        return topLabelAlignment.insets
    }
    
    var bottomLabelPadding: UIEdgeInsets {
        return bottomLabelAlignment.insets
    }
    
    var topLabelVerticalPadding: CGFloat {
        return topLabelPadding.top + topLabelPadding.bottom
    }
    var topLabelHorizontalPadding: CGFloat {
        return topLabelPadding.left + topLabelPadding.right
    }
    
    var bottomLabelVerticalPadding: CGFloat {
        return bottomLabelPadding.top + bottomLabelPadding.bottom
    }
    
    var bottomLabelHorizontalPadding: CGFloat {
        return bottomLabelPadding.left + bottomLabelPadding.right
    }
    
    
}

