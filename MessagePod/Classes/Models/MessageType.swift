//
//  MessageType.swift
//  MessagePod
//
//  Created by gang wang on 22/12/2017.
//

import Foundation

public protocol MessageType {
    
    var sender: Sender { get }
    var id: String { get }
    var data: MessageData { get }
    var date: Date { get }
    
}
