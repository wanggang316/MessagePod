//
//  ConversationViewController.swift
//  MessageUI_Example
//
//  Created by gang wang on 15/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MessagePod
import MapKit

class ConversationViewController: MessagesViewController {
    
    var messages: [AssistantMessage] = []

    let refreshControl = UIRefreshControl()
    
    lazy var tipsView: InputTipsView = {
        let view = InputTipsView.init(frame: CGRect.zero)
        view.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 35)
        view.didSelectedItemCallback = { [weak self] text in
            guard let `self` = self else { return }
            let id = UUID().uuidString
            let message = AssistantMessage.init(data: .text(text, nil), sender: MessageFactory.shared.currentSender, id: id, date: Date())
            self.messages.append(message)
            self.messageInputBar.inputTextView.text = String()
            self.messagesCollectionView.insertSections([self.messages.count - 1])
            self.messagesCollectionView.scrollToBottom()
            
            self.tipsView.items = MessageFactory.shared.getTips(count: 7)
            
        }
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addItem = UIBarButtonItem.init(title: "Map", style: .plain, target: self, action: #selector(addAction))
        let addCustomMessageItem = UIBarButtonItem.init(title: "Custom", style: .plain, target: self, action: #selector(addCustomMessageAction))

        self.navigationItem.rightBarButtonItems = [addCustomMessageItem, addItem]
        
        self.messagesCollectionView.backgroundColor = UIColor.init(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MessageFactory.shared.getMessages(count: 10) { messages in
                DispatchQueue.main.async {
                    self.messages = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
        
        messagesCollectionView.register(CustomCardMessageCell.self)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        messageInputBar.topView.addSubview(tipsView)

        tipsView.translatesAutoresizingMaskIntoConstraints = false
        tipsView.snp.makeConstraints { make in
            make.edges.equalTo(messageInputBar.topView)
        }
        
        tipsView.items = ["我要租房", "预约看房", "故障报修", "社区攻略", "联系管家", "勾搭小寓", "咨询其它问题"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func addAction() {
        let message = MessageFactory.shared.randomLocationMessage()
        messages.append(message)
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
    }
    
    @objc func addCustomMessageAction() {
        let message = MessageFactory.shared.randomCustomMessage()
        messages.append(message)
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 4) {
            MessageFactory.shared.getMessages(count: 10) { messages in
                DispatchQueue.main.async {
                    self.messages.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

}



extension ConversationViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return MessageFactory.shared.currentSender
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func cellTopLabelText(for message: MessageType, at indexPath: IndexPath) -> String? {
        return nil
    }
    
    func cellBottomLabelText(for message: MessageType, at indexPath: IndexPath) -> String? {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("Managed collectionView: \(collectionView.debugDescription) is not a MessagesCollectionView.")
        }
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        
        switch message.data {
        case .text(_, _):
            let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .location(_, _, _):
            let cell = messagesCollectionView.dequeueReusableCell(LocationMesssageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .custom(_):
            let cell = messagesCollectionView.dequeueReusableCell(CustomCardMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
    }
    
}


// MARK: - MessagesDisplayDelegate

extension ConversationViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    // MARK: - All Messages
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "map_point")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        switch message.data {
        case .custom(_):
            return .custom({ _ in })
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else { return .none }
            return dataSource.isCurrentSender(message: message) ? .bubbleRight : .bubbleLeft
        }
    }
}



// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {

    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageTop)
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        switch message.data {
        case .custom(_):
            return .zero
        default:
            return CGSize.init(width: 30, height: 30)
        }
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isCurrentSender(message: message) {
            switch message.data {
            case .text(_, _):
                return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 4)
            case .location(_, _, _):
                return UIEdgeInsets(top: 0, left: 40 + 25, bottom: 0, right: 4)
            case .custom(_):
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        } else {
            switch message.data {
            case .text(_, _):
                return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 40)
            case .location(_, _, _):
                return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 40 + 25)
            case .custom(_):
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
    
    // MARK: - Location Messages
//    func widthForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 250
//    }
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard case let .location(_, address, _) = message.data else { fatalError("") }
        let labelHeight = address.height(considering: maxWidth - 18, and: UIFont.systemFont(ofSize: 13))
        return 120 + labelHeight + 8 * 2
    }
    
    
    func widthForCustomView(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return UIScreen.main.bounds.width - 26
    }
    func heightForCustomView(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard case let .custom(data) = message.data else { fatalError("") }
        if let items = data as? [Apartment] {
            if items.count >= 2 {
                return 200 + 5 + 48
            } else if items.count == 1 {
                return 100 + 5 + 5
            } else {
                return 0
            }
        }
        return 0
    }

    
}


// MARK: - MessageCellDelegate

extension ConversationViewController: MessageCellDelegate {

}

// MARK: - MessageLabelDelegate

extension ConversationViewController: MessageLabelDelegate {
}


extension ConversationViewController: MessageInputViewDelegate {
    func messageInputView(_ inputView: MessageInputView, didPressSendButtonWith text: String) {
        let id = UUID().uuidString
        let message = AssistantMessage.init(data: .text(text, nil), sender: MessageFactory.shared.currentSender, id: id, date: Date())
        messages.append(message)
        inputView.inputTextView.text = String()
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
    }
}

