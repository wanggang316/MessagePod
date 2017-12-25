//
//  LabelAlignment.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation

// 使用枚举既能传递类型又传递了参数
public enum LabelAlignment {
    case cellLeading(UIEdgeInsets)
    case cellTrailing(UIEdgeInsets)
    case cellCenter(UIEdgeInsets)
    case messageLeading(UIEdgeInsets)
    case messageTrailing(UIEdgeInsets)
    
    public var insets: UIEdgeInsets {
        switch self {
        case .cellTrailing(let insets): return insets
        case .cellLeading(let insets): return insets
        case .cellCenter(let insets): return insets
        case .messageTrailing(let insets): return insets
        case .messageLeading(let insets): return insets
        }
    }
}
