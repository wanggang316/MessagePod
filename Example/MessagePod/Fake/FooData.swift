//
//  FooData.swift
//  gy
//
//  Created by wanggang on 2017/9/13.
//  Copyright © 2017年 Longfor. All rights reserved.
//

import UIKit

class FooData: NSObject {

    static func apartments() -> [String: Any]? {
        return readJSONFile("apartments")
    }
    
    static func apartments1() -> [String: Any]? {
        return readJSONFile("apartments1")
    }
    
    // MARK: - private methods
    private static func readJSONFile(_ name: String) -> [String: Any]? {
        let file = Bundle.main.path(forResource: name, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        return jsonData
    }
}
