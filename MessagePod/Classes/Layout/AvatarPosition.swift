//
//  AvatarPosition.swift
//  MessagePod
//
//  Created by gang wang on 17/12/2017.
//

import Foundation


public struct AvatarPosition {

    public enum Horizontal {
        case cellLeading
        case cellTrailing
        case natural
    }
    
    public enum Vertical {
        case cellTop
        case cellBottom
        case messageTop
        case messageBottom
        case messageCenter
    }
    
    
    public var vertical: Vertical
    public var horizontal: Horizontal
    
    public init(horizontal: Horizontal, vertical: Vertical) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public init(vertical: Vertical) {
        self.init(horizontal: .natural, vertical: vertical)
    }
}
