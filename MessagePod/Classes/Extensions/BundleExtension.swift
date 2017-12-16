//
//  BundleExtension.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

extension Bundle {
    static func messagePodBundle() -> Bundle {
        let frameworkBundle = Bundle.init(for: MessageViewController.self)
        guard let bundleURL = frameworkBundle.url(forResource: "MessagePodAssets", withExtension: "bundle") else {
            fatalError("MessagePod: Could not create path to the assets bundle")
        }
        guard let resourceBundle = Bundle.init(url: bundleURL) else {
            fatalError("MessagePod: Could not load the assets bundle")
        }
        return resourceBundle
    }
}
