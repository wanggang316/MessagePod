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
        
        self.messages = MessageData.messages
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
