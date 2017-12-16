//
//  MessageViewDelegate.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessageViewDelegate: AnyObject {
    
    
    func height(of row: Int) -> CGFloat
}
