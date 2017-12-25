//
//  MessagesLayoutDelegate.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessagesLayoutDelegate: AnyObject {
    
    // MARK: - layout
    /// - cell
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets

    /// - message label
    func messageLabelInset(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets

    /// - avatar
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// top & bottom label
    /// 上下 label 暂时采用居中样式，这样定义 label 的对齐方式似乎有点不对
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment

    /// header & footer view
    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize

    
    /// location
    func widthForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// should cache
    func shouldCacheLayoutAttributes(for message: MessageType) -> Bool

}


public extension MessagesLayoutDelegate {
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }
        if dataSource.isCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    // MARK: - message label
    func messageLabelInset(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }
        if dataSource.isCurrentSender(message: message) {
            return UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)
        } else {
            return UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
        }
    }
    
    // MARK: - Loaction
    func widthForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return maxWidth
    }
    
    // MARK: - Avatar
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    // MARK: - top & bottom label
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .cellCenter(.zero) }
        return dataSource.isCurrentSender(message: message) ? .messageTrailing(.zero) : .messageLeading(.zero)
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .cellCenter(.zero) }
        return dataSource.isCurrentSender(message: message) ? .messageLeading(.zero) : .messageTrailing(.zero)
    }
    
    // MARK: - Header & Footer view
    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else { return .zero }
        let shouldDisplay = displayDelegate.shouldDisplayHeader(for: message, at: indexPath, in: messagesCollectionView)
        return shouldDisplay ? CGSize(width: messagesCollectionView.bounds.width, height: 12) : .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - Cache
    func shouldCacheLayoutAttributes(for message: MessageType) -> Bool {
        return false
    }
}


