//
//  ApartmentSupport.swift
//  gy
//
//  Created by wanggang on 2017/9/16.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import Foundation

struct Amenitiy {
    
    let url: String?
    let desc: String

    init?(_ dictionary: [String: Any]) {
        guard let desc = dictionary["desc"] as? String else { return nil }
        self.desc = desc
        self.url = dictionary["url"] as? String
    }
    
    static func amenities(with array: [Any]) -> [Amenitiy] {
        var result = [Amenitiy]()
        if let tempArray = array as? [[String: Any]] {
            for dict in tempArray {
                if let amenity = Amenitiy(dict) {
                    result.append(amenity)
                }
            }
        }
        return result
    }
    
}

