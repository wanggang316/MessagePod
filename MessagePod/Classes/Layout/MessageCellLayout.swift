//
//  MessageCellLayout.swift
//  MessagePod
//
//  Created by gang wang on 17/12/2017.
//

import UIKit

open class MessageCellLayout {

    open weak var messageTableView: MessageTableView?
    
    fileprivate var messageDataSource: MessageViewDataSource {
        guard let messagesDataSource = self.messageTableView?.messageDataSource else {
            fatalError("MessageViewDataSource has not been set.")
        }
        return messagesDataSource
    }
    
    fileprivate var messageDelegate: MessageViewDelegate {
        guard let messagesDataSource = self.messageTableView?.messageDelegate else {
            fatalError("MessageViewDelegate has not been set.")
        }
        return messagesDataSource
    }
    
    typealias MessageID = String
    fileprivate var messageCellAttributes: [MessageID: MessageCellLayoutAttributes] = [:]

    
    fileprivate var itemWidth: CGFloat {
        guard let messageTableView = messageTableView else { return 0 }
        return UIScreen.main.bounds.width - messageTableView.contentInset.left - messageTableView.contentInset.right
    }
    
    func messageCellLayoutAttributes(for indexPath: IndexPath) -> MessageCellLayoutAttributes {
        
        guard let message = messageDataSource.messageForItem(at: indexPath, in: messageTableView!) else {
            fatalError("MessageCellLayout messageCellLayoutAttributes message is nil.")
        }
        
        if let attributes = messageCellAttributes[String(message.text.hashValue)] {
            return attributes
        } else {
            let newAttributes = createMessageLayoutAttributes(for: message, at: indexPath)
            messageCellAttributes[String(message.text.hashValue)] = newAttributes
            return newAttributes
        }
        
    }
    
    
    func createMessageLayoutAttributes(for message: Message, at indexPath: IndexPath) -> MessageCellLayoutAttributes {
        
//        attributes.avatarPosition =
        let position = messageDelegate.avatarPosition(for: message, at: indexPath, in: messageTableView!)

        let attributes = MessageCellLayoutAttributes(message: message, indexPath: indexPath, avatarPosition: position)
        
        // None of these are dependent on other attributes
        attributes.avatarSize = avatarSize(for: attributes)
        attributes.messageContainerPadding = messageContainerPadding(for: attributes)
        attributes.messageLabelInsets = messageLabelInsets(for: attributes)
//
//        // MessageContainerView
        attributes.messageContainerMaxWidth = messageContainerMaxWidth(for: attributes)
        attributes.messageContainerSize = messageContainerSize(for: attributes)
//
//        // Cell Bottom Label
//        attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: attributes)
//        attributes.bottomLabelMaxWidth = cellBottomLabelMaxWidth(for: attributes)
//        attributes.bottomLabelSize = cellBottomLabelSize(for: attributes)
//        
//        // Cell Top Label
//        attributes.topLabelAlignment = cellTopLabelAlignment(for: attributes)
//        attributes.topLabelMaxWidth = cellTopLabelMaxWidth(for: attributes)
//        attributes.topLabelSize = cellTopLabelSize(for: attributes)
//        
//        // Cell Height
        attributes.itemHeight = cellHeight(for: attributes)
        attributes.itemWidth = cellWidth(for: attributes)
        
        return attributes
    }
    
    
}

private extension MessageCellLayout {
    
    /// Returns the size required to fit a String considering a constrained max width.
    ///
    /// - Parameters:
    ///   - text: The `String` used to calculate a size that fits.
    ///   - maxWidth: The max width available for the label.
    func labelSize(for text: String, considering maxWidth: CGFloat, and font: UIFont) -> CGSize {
        
        let estimatedHeight = text.height(considering: maxWidth, and: font)
        let estimatedWidth = text.width(considering: estimatedHeight, and: font)
        
        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
    
}

// MARK: - avatar
extension MessageCellLayout {
    func avatarPosition(for attributes: MessageCellLayoutAttributes) -> AvatarPosition {
        let position = messageDelegate.avatarPosition(for: attributes.message, at: attributes.indexPath, in: messageTableView!)
        return position
    }
    
    func avatarSize(for attributes: MessageCellLayoutAttributes) -> CGSize {
        return messageDelegate.avatarSize(for: attributes.message, at: attributes.indexPath, in: messageTableView!)
    }
}



// MARK: - messasge container

extension MessageCellLayout {
    
    func messageContainerPadding(for attributes: MessageCellLayoutAttributes) -> UIEdgeInsets {
        return messageDelegate.messagePadding(for: attributes.message, at: attributes.indexPath, in: messageTableView!)
    }

    func messageLabelInsets(for attributes: MessageCellLayoutAttributes) -> UIEdgeInsets {
        return messageDelegate.messageLabelInset(for: attributes.message, at: attributes.indexPath, in: messageTableView!)
    }
    
    func messageContainerSize(for attributes: MessageCellLayoutAttributes) -> CGSize {
        
        let message = attributes.message
//        let indexPath = attributes.indexPath
        let maxWidth = attributes.messageContainerMaxWidth
        
        var messageContainerSize: CGSize = .zero
        
        messageContainerSize = labelSize(for: message.text, considering: maxWidth, and: attributes.messageLabelFont)
        messageContainerSize.width += attributes.messageLabelHorizontalInsets
        messageContainerSize.height += attributes.messageLabelVerticalInsets

        return messageContainerSize
        
    }
    
    func messageContainerMaxWidth(for attributes: MessageCellLayoutAttributes) -> CGFloat {
        return itemWidth - attributes.avatarSize.width - attributes.avatarHorizontalInset - attributes.messageHorizontalPadding - attributes.messageLabelHorizontalInsets
    }
}



// MARK: - Cell Sizing

private extension MessageCellLayout {
    
    private func cellHeight(for attributes: MessageCellLayoutAttributes) -> CGFloat {
        var cellHeight: CGFloat = 0
        cellHeight += attributes.messageContainerSize.height
        cellHeight += attributes.messageVerticalPadding
        return cellHeight
    }
    
    private func cellWidth(for attributes: MessageCellLayoutAttributes) -> CGFloat {
        return messageDelegate.messageCellWidth(at: attributes.indexPath, in: messageTableView!)
    }

}
