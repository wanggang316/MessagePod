//
//  MessageViewDelegate.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessageViewDelegate: AnyObject {
    
//    var layoutAttributes: [String: CGSize]
    
//    func height(of indexPath: IndexPath) -> CGFloat
    
    // MARK: - layout
    
    /// - cell
    func messageCellWidth(at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGFloat
    
    /// - message label
    func messagePadding(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets
    func messageLabelInset(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets

    /// - avatar
    func avatarPosition(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> AvatarPosition
    func avatarSize(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGSize

}
