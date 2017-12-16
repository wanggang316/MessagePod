//
//  MessageViewDataSource.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public protocol MessageViewDataSource: AnyObject {
    
    func number(of row: Int) -> Int
}
