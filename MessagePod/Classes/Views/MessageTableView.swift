//
//  MessageTableView.swift
//  MessageUI
//
//  Created by gang wang on 14/12/2017.
//

import UIKit

open class MessageTableView: UITableView {

    open weak var messageDataSource: MessageViewDataSource?
    open weak var messageDelegate: MessageViewDelegate?

}
