
//
//  ApartmentImage.swift
//  gy
//
//  Created by wanggang on 2017/9/16.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import Foundation

/** 房源图片
 */
struct ApartmentImage {
    let title: String?
    let image: String?
    
    init?(_ dictionary: [String: Any]) {
        self.image = dictionary["img"] as? String
        self.title = dictionary["title"] as? String
    }
    
    static func images(with array: [Any]) -> [ApartmentImage] {
        var result = [ApartmentImage]()
        if let tempArray = array as? [[String: Any]] {
            for dict in tempArray {
                if let image = ApartmentImage(dict) {
                    result.append(image)
                }
            }
        }
        return result
    }
}
