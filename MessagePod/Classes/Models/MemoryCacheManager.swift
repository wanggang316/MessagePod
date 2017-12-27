//
//  MemoryCacheManager.swift
//  MessagePod
//
//  Created by gang wang on 27/12/2017.
//

import UIKit

public class MemoryCacheManager {
    
    static let shared = MemoryCacheManager()
    private init() {}
    
    private var cachedItems: [String: UIImage] = [:]
    
    func cache(_ image: UIImage, for key: String) {
        cachedItems[key] = image
    }
    
    func cachedImage(for key: String) -> UIImage? {
        return cachedItems[key]
    }
}
