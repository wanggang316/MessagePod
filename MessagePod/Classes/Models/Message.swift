//
//  Message.swift
//  MessageUI
//
//  Created by gang wang on 14/12/2017.
//

import Foundation

public struct Message {
    public let sender: Sender
    public var text: String
    public var actions: [String: String]?
    
    public init(sender: Sender, text: String, actions: [String: String]? = nil) {
        self.sender = sender
        self.text = text
        self.actions = actions
    }
    
}

extension Message: Equatable {
    static public func == (left: Message, right: Message) -> Bool {
        return left.text.hashValue == right.text.hashValue
    }
}
