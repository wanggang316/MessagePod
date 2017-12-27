//
//  Apartment.swift
//  gy
//
//  Created by wanggang on 2017/9/13.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import Foundation

struct Apartment {
    let id: Int?
    let name: String?
    let status: Bool
    let price: String?
    let imageURL: String?
    let images: [ApartmentImage]?
    let supports: [Amenitiy]?
//    let facilities: [Amenitiy]?
    let roomTypeCount: Int
    let minArea: String?
    let roomCount: String?
    let desc: String?
    let address: String?
    let lat: String?
    let lon: String?
    let roomTypes: [RoomType]?
    let serviceAgreement: String? // 邻里合约
    let shareURL: String?
    let shareTitle: String?
    let shareText: String?
    
//    let starCustomers: [Customer]?
//    let activities: [Activity]?
    let phoneNum: String?
    let panoramaURL: String?
    
    init?(_ dictionary: [String: Any]) {
        if let ID = dictionary["id"] as? Int {
            self.id = ID
        } else if let ID = dictionary["id"] as? String {
             self.id = Int(ID)
        } else {
            if let code = dictionary["code"] as? String {
                self.id = Int.init(code)
            } else {
                self.id = nil
            }
        }
        self.name = dictionary["name"] as? String
        
        if let num = dictionary["status"] as? NSNumber {
            self.status = num.boolValue
        } else {
            self.status = true
        }
        
        self.price = dictionary["price"] as? String
//        if let price = dictionary["price"] as? String, price != "0" {
//            self.price = price
//        } else {
//            self.price = "已满租"
//        }
        self.imageURL = dictionary["imgUrl"] as? String
        if let array = dictionary["images"] as? [Any] {
            self.images = ApartmentImage.images(with: array)
        } else {
            if let imageURL = self.imageURL, let image = ApartmentImage.init(["title": "", "img": imageURL]) {
                self.images = [image]
            } else {
                self.images = []
            }
        }
        if let array = dictionary["supports"] as? [Any] {
            self.supports = Amenitiy.amenities(with: array)
        } else if let array = dictionary["facilities"] as? [Any] {
            self.supports = Amenitiy.amenities(with: array)
        } else {
            self.supports = []
        }
//        if let array = dictionary["facilities"]  as? [Any] {
//            self.facilities = Amenitiy.amenities(with: array)
//        } else {
//            self.facilities = []
//        }
        if let count = dictionary["roomTypeCount"] as? Int {
            self.roomTypeCount = count
        } else if let count = dictionary["roomTypeCount"] as? String {
            self.roomTypeCount = Int.init(count) ?? 0
        } else {
            self.roomTypeCount = 0
        }
        self.minArea = dictionary["minArea"] as? String
        self.roomCount = dictionary["roomCount"] as? String
        self.desc = dictionary["description"] as? String
        self.address = dictionary["address"] as? String
        
        if let lat = dictionary["lat"] as? String, lat != "0E-7" {
            self.lat = lat
        } else {
            self.lat = nil
        }
        if let lon = dictionary["lon"] as? String, lon != "0E-7" {
            self.lon = lon
        } else {
            self.lon = nil
        }
        
        if let array = dictionary["roomTypes"] as? [Any] {
            self.roomTypes = RoomType.roomTypes(with: array)
        } else {
            self.roomTypes = []
        }
        self.serviceAgreement = dictionary["serviceAgreement"] as? String

//        if let array = dictionary["starCustomers"] as? [Any] {
//            self.starCustomers = Customer.customers(with: array)
//        } else {
//            self.starCustomers = []
//        }
//        if let array = dictionary["activities"] as? [Any] {
//            self.activities = Activity.activities(with: array)
//        } else {
//            self.activities = []
//        }
        self.phoneNum = dictionary["phoneNumber"] as? String
        self.panoramaURL = dictionary["panoramaUrl"] as? String // "http://720yun.com/t/ce2jz0svku6?from=groupmessage&isappinstalled=0&pano_id=6146300"
        
        self.shareURL = dictionary["shareUrl"] as? String
        self.shareTitle = dictionary["shareTitle"] as? String
        self.shareText = dictionary["shareText"] as? String
    }
    
    static func apartments(with array: [Any]) -> [Apartment] {
        var result = [Apartment]()
        if let tempArray = array as? [[String: Any]] {
            for dict in tempArray {
                if let house = Apartment(dict) {
                    result.append(house)
                }
             }
        }
        return result
    }
}
