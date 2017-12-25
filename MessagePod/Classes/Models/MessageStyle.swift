//
//  MessageStyle.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation

public enum MessageStyle {
    case none
    case bubbleLeft
    case bubbleRight
    case custom((MessageContainerView) -> Void)
    
    // MARK: - Public

    public var image: UIImage? {
        
        guard let imageName = imageName else { return nil }
        guard let path = Bundle.imagePath(for: imageName) else { return nil }
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        
        return image.stretch()
    }
    
    // MARK: - Private
    
    private var imageName: String? {
        switch self {
        case .bubbleLeft:
            return "bubble_in@2x"
        case .bubbleRight:
            return "bubble_out@2x"
        case .none, .custom:
            return nil
        }
    }
    
    
}
