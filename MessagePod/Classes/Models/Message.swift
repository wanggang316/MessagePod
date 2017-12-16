//
//  Message.swift
//  MessageUI
//
//  Created by gang wang on 14/12/2017.
//

import Foundation

public struct Message {
//    public let sender: Sender
    public var text: String
    public var actions: [String: String]?
//    public var attributeText: NSAttributedString
    
    public init(text: String, actions: [String: String]?) {
        self.text = text
        self.actions = actions
    }
    
}
