//
//  RoomType.swift
//  gy
//
//  Created by wanggang on 2017/9/16.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import Foundation

struct RoomType {
    let id: String?
    let theme: String?
    let name: String?
    let type: String?
    let area: String?
    let price: String?
    let introduction: String?
    let amenities: [Amenitiy]?
    let img: [String]?
    
    init?(_ dictionary: [String: Any]) {
        guard let ID = dictionary["id"] as? String else { return nil }
        self.id = ID
        self.theme = dictionary["theme"] as? String
        self.name = dictionary["name"] as? String
        self.type = dictionary["type"] as? String
        self.area = dictionary["area"] as? String
        self.price = dictionary["price"] as? String
//        if let price = dictionary["price"] as? String, price != "0" {
//            self.price = price
//        } else {
//            self.price = "已满租"
//        }
        self.introduction = dictionary["introduction"] as? String
        if let array = dictionary["amenities"] as? [Any] {
            self.amenities = Amenitiy.amenities(with: array)
        } else {
            self.amenities = []
        }
        if let array = dictionary["img"] as? [String] {
            self.img = array
        } else {
            self.img = []
        }
    }
    
    static func roomTypes(with array: [Any]) -> [RoomType] {
        var result = [RoomType]()
        if let tempArray = array as? [[String: Any]] {
            for dict in tempArray {
                if let roomType = RoomType(dict) {
                    result.append(roomType)
                }
            }
        }
        return result
    }
    
}
