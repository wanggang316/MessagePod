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
        
        self.messages = MessageData.messages
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//extension ConversationViewController {
//    func bubbleImage(for message: Message, in messageTableView: MessageTableView) -> UIImage? {
//        return UIImage()
//    }
//}

