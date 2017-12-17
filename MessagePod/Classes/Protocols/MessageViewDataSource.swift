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

}


public extension MessageViewDataSource {
    
    func isCurrentSender(message: Message) -> Bool {
        return message.sender == currentSender()
    }
    
}
