//
//  BundleExtension.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

extension Bundle {
    static func messagePodBundle() -> Bundle {
        let frameworkBundle = Bundle.init(for: MessagesViewController.self)
        guard let bundleURL = frameworkBundle.url(forResource: "MessagePodAssets", withExtension: "bundle") else {
            fatalError("MessagePod: Could not create path to the assets bundle")
        }
        guard let resourceBundle = Bundle.init(url: bundleURL) else {
            fatalError("MessagePod: Could not load the assets bundle")
        }
        return resourceBundle
    }
    
    static func imagePath(for imageName: String, withEextension ext: String? = "png") -> String? {
        let assetBundle = Bundle.messagePodBundle()
        guard let path = assetBundle.path(forResource: imageName, ofType: ext, inDirectory: "images") else {
            fatalError("MessagePod: Could not find the image")
        }
        return path
    }
}
