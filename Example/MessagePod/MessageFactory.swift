//
//  MessageData.swift
//  MessagePod_Example
//
//  Created by gang wang on 16/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MessagePod

final class MessageFactory {

    static let shared = MessageFactory()
    
    private init() {}
    
    let messageTextValues = [
        "Ok",
        "k",
        "lol",
        "1-800-555-0000",
        "One Infinite Loop Cupertino, CA 95014 This is some extra text that should not be detected.",
        "This is an example of the date detector 11/11/2017. April 1st is April Fools Day. Next Friday is not Friday the 13th.",
        "https://github.com/SD10",
        "Check out this awesome UI library for Chat",
        "My favorite things in life don’t cost any money. It’s really clear that the most precious resource we all have is time.",
        """
            You know, this iPhone, as a matter of fact, the engine in here is made in America.
            And not only are the engines in here made in America, but engines are made in America and are exported.
            The glass on this phone is made in Kentucky. And so we've been working for years on doing more and more in the United States.
            """,
        """
            Remembering that I'll be dead soon is the most important tool I've ever encountered to help me make the big choices in life.
            Because almost everything - all external expectations, all pride, all fear of embarrassment or failure -
            these things just fall away in the face of death, leaving only what is truly important.
            """,
        "I think if you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next.",
        "Price is rarely the most important thing. A cheap product might sell some units. Somebody gets it home and they feel great when they pay the money, but then they get it home and use it and the joy is gone."
    ]
    
    let outgoingSender = Sender.init(id: "0", name: "", image: #imageLiteral(resourceName: "avatar-placeholder"))
    let incommingSender = Sender.init(id: "1", name: "", image: #imageLiteral(resourceName: "avatar"))
    
    lazy var senders = [outgoingSender, incommingSender]
    
    var currentSender: Sender {
        return outgoingSender
    }

    var now = Date()

    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessage() -> AssistantMessage {

        let randomNumberText = Int(arc4random_uniform(UInt32(messageTextValues.count)))
        let randomNumberSender = Int(arc4random_uniform(UInt32(senders.count)))

        let uniqueID = NSUUID().uuidString
        let sender = senders[randomNumberSender]
        let date = dateAddingRandomTime()
        
        return AssistantMessage(data: MessageData.text(messageTextValues[randomNumberText], nil), sender: sender, id: uniqueID, date: date)
    }

    
    func getMessages(count: Int, completion: ([AssistantMessage]) -> Void) {
        var messages: [AssistantMessage] = []
        for _ in 0..<count {
            messages.append(randomMessage())
        }
        completion(messages)
    }
    
    func newAttributeMessage() -> AssistantMessage {
        let number = Int(arc4random_uniform(UInt32(amessages.count)))
        return amessages[number]
    }

    
    
    lazy var amessages: [AssistantMessage] = [
        AssistantMessage(data: MessageData.text("本项目并非 Google 官方项目, @而是由国内程序员凭热情创建和维护", ["程序员": "http://www.google.com"]), sender: incommingSender, id: "1", date: Date()),
        AssistantMessage(data: MessageData.text("如果你关注的是 Google 官方英文版", ["英文": "guanyu://page.gy/dbf"]), sender: outgoingSender, id: "2", date: Date()),
        AssistantMessage(data: MessageData.text("每个较大的开源项目都有自己的风格指南: #关于 如何为该项目编写代码的一系列约定 (有时候会比较武断). 当所有代码均保持一致的风格, 在理解大型代码库时更为轻松", nil), sender: outgoingSender, id: "3", date: Date()),
        AssistantMessage(data: MessageData.text("\"风格\" 的含义涵盖范围广, 从 \"变量使用驼峰格式 (camelCase)\" 到 \"决不使用全局变量\" 再到 \"决不使用异常\". 英文版项目维护的是在 Google 使用的编程风格指南. 如果你正在修改的项目源自 Google, 你可能会被引导至 英文版项目页面, 以了解项目所使用的风格.", ["camelCase": "guanyu://page.gy/ddddd", "使用": "abcd"]), sender: outgoingSender, id: "4", date: Date()),
        AssistantMessage(data: MessageData.text("Google C++ 风格指南是的哈哈哈哈哈", nil), sender: outgoingSender, id: "5", date: Date())
    ]
    
    static func attributeString(for text: String) -> NSAttributedString {
        let atrributeString = NSMutableAttributedString.init(string: text)
        let range = NSRange(location: 0, length: text.count)
        atrributeString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: range)
        atrributeString.addAttribute(.link, value: UIFont.systemFont(ofSize: 14), range: range)
        return atrributeString
    }
    
    
    // MARK: - tips data
    let tips: [String] =  ["我要租房", "预约看房dd", "故障报修是的", "社区", "联系管家", "搭小寓", "咨询其它问题"]
    
    func randomTip() -> String {
        let randomNumberTip = Int(arc4random_uniform(UInt32(tips.count)))
        return tips[randomNumberTip]
    }
    
    func getTips(count: Int) -> [String] {
        var tips: [String] = []
        for _ in 0..<count {
            tips.append(randomTip())
        }
        return tips
    }
    
}
