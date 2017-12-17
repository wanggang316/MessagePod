//
//  AvatarPosition.swift
//  MessagePod
//
//  Created by gang wang on 17/12/2017.
//

import Foundation


public struct AvatarPosition {

    public enum Side {
        case cellLeading
        case cellTrailing
    }
    
    
    public var side: Side
    public var margin: UIEdgeInsets = .zero
    
    public init(side: Side, margin: UIEdgeInsets) {
        self.side = side
        self.margin = margin
    }
}
