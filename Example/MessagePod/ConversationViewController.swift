//
//  ConversationViewController.swift
//  MessageUI_Example
//
//  Created by gang wang on 15/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MessagePod

class ConversationViewController: MessageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.backgroundColor = UIColor.init(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            SampleData.shared.getMessages(count: 30) { messages in
//                DispatchQueue.main.async {
                    self.messages = MessageData.messages
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//extension ConversationViewController: MessageInputViewDelegate {
//
//    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        //        messageList.append(MockMessage(text: text, sender: currentSender(), messageId: UUID().uuidString, date: Date()))
//        //        inputBar.inputTextView.text = String()
//        //        messagesCollectionView.insertSections([messageList.count - 1])
//        //        messagesCollectionView.scrollToBottom()
//
//    }
//
//
//    func messageInputView(_ inputView: MessageInputView, textViewTextDidChangeTo text: String) {
//        print(text)
//    }
//}

