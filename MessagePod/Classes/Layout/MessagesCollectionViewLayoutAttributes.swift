//
//  MessagesCollectionViewLayoutAttributes.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation

final class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // MARK: - Properties
    
    var avatarFrame: CGRect = .zero
    
    var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    var messageContainerFrame: CGRect = .zero
    var messageLabelInsets: UIEdgeInsets = .zero
    
    var topLabelFrame: CGRect = .zero
    var bottomLabelFrame: CGRect = .zero
    
    // MARK: - Methods
    
    override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.avatarFrame = avatarFrame
        copy.messageContainerFrame = messageContainerFrame
        copy.messageLabelFont = messageLabelFont
        copy.messageLabelInsets = messageLabelInsets
        copy.topLabelFrame = topLabelFrame
        copy.bottomLabelFrame = bottomLabelFrame
        return copy
        // swiftlint:enable force_cast
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        // MARK: - LEAVE this as is
        // swiftlint:disable unused_optional_binding
        if let _ = object as? MessagesCollectionViewLayoutAttributes {
            return super.isEqual(object)
        } else {
            return false
        }
        // swiftlint:enable unused_optional_binding
    }
    
    
}
