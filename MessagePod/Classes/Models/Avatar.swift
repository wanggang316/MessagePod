//
//  Avatar.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation


public struct Avatar {
    
    // MARK: - Properties

    public let image: UIImage?

    public var initials: String = "?"
    
    // MARK: - Initializer
    public init(image: UIImage? = nil, initials: String = "?") {
        self.image = image
        self.initials = initials
    }
    
}
