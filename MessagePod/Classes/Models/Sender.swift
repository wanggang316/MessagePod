//
//  Sender.swift
//  MessageUI
//
//  Created by gang wang on 14/12/2017.
//

import Foundation

public struct Sender {
    
    public let id: String
    public let name: String
    public let image: UIImage
    
    public init(id: String, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
}

extension Sender: Equatable {
    static public func == (left: Sender, right: Sender) -> Bool {
        return left.id == right.id
    }
}
