//
//  AssistantMessage.swift
//  MessagePod_Example
//
//  Created by gang wang on 26/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MessagePod

struct AssistantMessage: MessageType {
    
    var id: String
    var sender: Sender
    var date: Date
    var data: MessageData
    
    init(data: MessageData, sender: Sender, id: String, date: Date) {
        self.data = data
        self.sender = sender
        self.id = id
        self.date = date
    }
    
}
