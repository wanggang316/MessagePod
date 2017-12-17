//
//  MessageViewDelegate.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessageViewDelegate: AnyObject {
    
//    var layoutAttributes: [String: CGSize]
    
    func height(of row: Int) -> CGFloat
    
    
    
    // MARK: - layout
    
    /// - message label
    func messagePadding(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets
    func messageLabelInset(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets

    /// - avatar
    func avatarPosition(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGPoint
    func avatarSize(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGSize

}
