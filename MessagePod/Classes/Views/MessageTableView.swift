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

    
    private var indexPathForLastItem: IndexPath? {
        
        let lastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        guard numberOfRows(inSection: lastSection) > 0 else { return nil }
        return IndexPath(item: numberOfRows(inSection: lastSection) - 1, section: lastSection)
    }
    
    
    // MARK: - Methods
    
    public func scrollToBottom(animated: Bool = true) {
        guard let indexPath = indexPathForLastItem else { return }
        scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
    }
}
