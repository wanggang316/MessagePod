//
//  MessagesDataSource.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessagesDataSource: AnyObject {
    
    func currentSender() -> Sender
    
    func isCurrentSender(message: MessageType) -> Bool

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType

//    func avatar(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar

//    func bubbleImage(for message: Message, in messageTableView: MessageTableView) -> UIImage?
    
    /// 暂时传入 string，不传入 NSAttributedString
    func cellTopLabelText(for message: MessageType, at indexPath: IndexPath) -> String?

    func cellBottomLabelText(for message: MessageType, at indexPath: IndexPath) -> String?

}


public extension MessagesDataSource {
    
    func isCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender()
    }
    
    
    func cellTopLabelText(for message: MessageType, at indexPath: IndexPath) -> String? {
        return nil
    }
    
    func cellBottomLabelText(for message: MessageType, at indexPath: IndexPath) -> String? {
        return nil
    }
    
//    func bubbleImage(for message: Message, in messageTableView: MessageTableView) -> UIImage? {
//        return UIImage()
//        var name = "bubble_in@2x"
//        if isCurrentSender(message: message) {
//            name = "bubble_out@2x"
//        }
//        guard let path = Bundle.imagePath(for: name) else { return nil }
//        return UIImage.init(contentsOfFile: path)//?.stretch()
//    }
    
}
