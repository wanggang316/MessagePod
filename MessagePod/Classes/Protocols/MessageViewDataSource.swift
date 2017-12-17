//
//  MessageViewDataSource.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessageViewDataSource: AnyObject {
    
    func currentSender() -> Sender
    func isCurrentSender(message: Message) -> Bool
    
    func numberofRows(in messageTableView: MessageTableView) -> Int
    func messageForItem(at indexPath: IndexPath, in messageTableView: MessageTableView) -> Message?

    func bubbleImage(for message: Message, in messageTableView: MessageTableView) -> UIImage?
}


public extension MessageViewDataSource {
    
    func isCurrentSender(message: Message) -> Bool {
        return message.sender == currentSender()
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
