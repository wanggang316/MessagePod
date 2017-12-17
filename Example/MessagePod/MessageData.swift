//
//  MessageData.swift
//  MessagePod_Example
//
//  Created by gang wang on 16/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MessagePod

struct MessageData {

    static var messages: [Message] = [
        Message(sender: Sender.init(id: "1", name: "", image: UIImage.init(named: "avatar")!), text: "本项目并非 Google 官方项目, @而是由国 内程序员凭热情创建和维护", actions: ["程序员": "guanyu://page.gy/abc"]),
        Message(sender: Sender.init(id: "2", name: "", image: UIImage.init(named: "avatar-placeholder")!), text: "如果你关注的是 Google 官方英文版", actions: ["英文": "guanyu://page.gy/dbf"]),
        Message(sender: Sender.init(id: "1", name: "", image: UIImage.init(named: "avatar")!), text: "每个较大的开源项目都有自己的风格指南: #关于 如何为该项目编写代码的一系列约定 (有时候会比较武断). 当所有代码均保持一致的风格, 在理解大型代码库时更为轻松", actions: nil),
        Message(sender: Sender.init(id: "1", name: "", image: UIImage.init(named: "avatar")!), text: "\"风格\" 的含义涵盖范围广, 从 \"变量使用驼峰格式 (camelCase)\" 到 \"决不使用全局变量\" 再到 \"决不使用异常\". 英文版项目维护的是在 Google 使用的编程风格指南. 如果你正在修改的项目源自 Google, 你可能会被引导至 英文版项目页面, 以了解项目所使用的风格.", actions: ["camelCase": "guanyu://page.gy/ddddd", "使用": "abcd"]),
        Message(sender: Sender.init(id: "2", name: "", image: UIImage.init(named: "avatar-placeholder")!), text: "Google C++ 风格指南 http://www.baidu.com", actions: nil),
        Message(sender: Sender.init(id: "1", name: "", image: UIImage.init(named: "avatar")!), text: "Google Objective-C 风格指南", actions: nil)
        
//        Message(attributeText: MessageData.attributeString(for: "本项目并非 Google 官方项目, 而是由国内程序员凭热情创建和维护")),
//        Message(attributeText: MessageData.attributeString(for: "如果你关注的是 @Google 官方英文版")),
//        Message(attributeText: MessageData.attributeString(for: "每个较大的开源项 18310059095 目都有自己的风格指南: 关于如何为该项目编写代码的一系列约定 (有时候会比较#武断 ). 当所有代码均保持一致的风格, 在理解大型代码库时更为轻松")),
//        Message(attributeText: MessageData.attributeString(for: "\"风格\" 的含义 #涵盖范围广, 从 \"变量使用驼峰格式 (camelCase)\" 到 \"决不使用全局变量\" 再到 \"决不使用异常\". 英文版项目维护的是在 Google 使用的编程风格指南. 如果你正在修改的项目源自 Google, 你可能会被引导至 英文版项目页面, 以了解项目所使用的风格.")),
//        Message(attributeText: MessageData.attributeString(for: "Google C++ 风 2018-08-08 格指南 http://www.baidu.com")),
//        Message(attributeText: MessageData.attributeString(for: "Google Objective-C 风格指南"))
    ]
    
    static func attributeString(for text: String) -> NSAttributedString {
        let atrributeString = NSMutableAttributedString.init(string: text)
        let range = NSRange(location: 0, length: text.count)
        atrributeString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: range)
        atrributeString.addAttribute(.link, value: UIFont.systemFont(ofSize: 14), range: range)

        return atrributeString
    }
}
