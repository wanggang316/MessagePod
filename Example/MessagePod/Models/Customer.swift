//
//  Customer.swift
//  gy
//
//  Created by wanggang on 2017/9/16.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import Foundation

struct Customer {
    let id: Int
    let name: String?
    let avatar: String?
    let introduction: String?
    
    init?(_ dictionary: [String: Any]) {
        guard let ID = dictionary["id"] as? Int else { return nil }
        self.id = ID
        self.name = dictionary["name"] as? String
        self.avatar = dictionary["avatar"] as? String
        self.introduction = dictionary["introduction"] as? String
    }
    
    static func customers(with array: [Any]) -> [Customer] {
        var result = [Customer]()
        if let tempArray = array as? [[String: Any]] {
            for dict in tempArray {
                if let customer = Customer(dict) {
                    result.append(customer)
                }
            }
        }
        return result
    }
    
}
