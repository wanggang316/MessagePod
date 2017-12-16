//
//  Sender.swift
//  MessageUI
//
//  Created by gang wang on 14/12/2017.
//

import Foundation

public struct Sender {
    open let id: String
    open let name: String
}

extension Sender: Equatable {
    static public func == (left: Sender, right: Sender) -> Bool {
        return left.id == right.id
    }
}
