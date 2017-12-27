//
//  MessageContainerView.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessageContainerView: UIImageView {

    // MARK: - Properties
    
    private let imageMask = UIImageView()
    
    open var style: MessageStyle = .none {
        didSet {
            applyMessageStyle()
        }
    }

    open override var frame: CGRect {
        didSet {
            sizeMaskToView()
        }
    }

    
    // MARK: - Methods
    
    private func sizeMaskToView() {
        switch style {
        case .none, .custom:
            break
        case .bubbleLeft, .bubbleRight:
            imageMask.frame = bounds
        }
    }
    
    private func applyMessageStyle() {
        switch style {
        case .bubbleLeft, .bubbleRight:
            imageMask.image = style.image
            sizeMaskToView()
            mask = imageMask
            image = style.image
        case .none:
            mask = nil
            image = nil
            tintColor = nil
        case .custom(let configurationClosure):
            mask = nil
            image = nil
            tintColor = nil
            configurationClosure(self)
        }
    }
}
