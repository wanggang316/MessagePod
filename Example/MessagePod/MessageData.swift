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
        Message(text: "本项目并非 Google 官方项目, 而是由国内程序员凭热情创建和维护"),
        Message(text: "如果你关注的是 Google 官方英文版"),
        Message(text: "每个较大的开源项目都有自己的风格指南: 关于如何为该项目编写代码的一系列约定 (有时候会比较武断). 当所有代码均保持一致的风格, 在理解大型代码库时更为轻松"),
        Message(text: "\"风格\" 的含义涵盖范围广, 从 \"变量使用驼峰格式 (camelCase)\" 到 \"决不使用全局变量\" 再到 \"决不使用异常\". 英文版项目维护的是在 Google 使用的编程风格指南. 如果你正在修改的项目源自 Google, 你可能会被引导至 英文版项目页面, 以了解项目所使用的风格."),
        Message(text: "Google C++ 风格指南"),
        Message(text: "Google Objective-C 风格指南")
    ]
}
