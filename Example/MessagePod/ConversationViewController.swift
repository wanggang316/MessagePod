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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: #selector(addAction))
        
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
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        defaultStyle()
        
        
        messageInputBar.topView.addSubview(tipsView)

        
        tipsView.translatesAutoresizingMaskIntoConstraints = false
        tipsView.snp.makeConstraints { make in
            make.edges.equalTo(messageInputBar.topView)
        }
        
        configTips(items: ["我要租房", "预约看房", "故障报修", "社区攻略", "联系管家", "勾搭小寓", "咨询其它问题"])
//        configTips(items: ["我要租房"])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func addAction() {
        let message = MessageFactory.shared.randomLocationMessage()
        messages.append(message)
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
        
//        configTips(items: ["hello"])
//        messageInputBar.padding.top =  messageInputBar.padding.top == 6 ? 6 + 36 : 6
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        tipsView.topAnchor.constraint(equalTo: messageInputBar.topView.topAnchor, constant: 0).isActive = true
//        tipsView.bottomAnchor.constraint(equalTo: messageInputBar.topView.bottomAnchor, constant: 0).isActive = true
//        tipsView.leadingAnchor.constraint(equalTo: messageInputBar.topView.leadingAnchor, constant: 0).isActive = true
//        tipsView.trailingAnchor.constraint(equalTo: messageInputBar.topView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    func configTips(items: [String]) {
        
        
        
  
        tipsView.items = items

        
        if items.count == 0 {
            
//            messageInputBar.topStackView.arrangedSubviews.first?.removeFromSuperview()
//            messageInputBar.topStackViewPadding = .zero
            
        } else {
            
//            let label = UILabel()
//            label.backgroundColor = UIColor.yellow
//            label.text = "nathan.tannar is typing..."
//            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            
//            messageInputBar.topStackView.addArrangedSubview(tipsView)
//
//            messageInputBar.topStackViewPadding.top = 6
//            messageInputBar.topStackViewPadding.left = 12
//
//            // The backgroundView doesn't include the topStackView. This is so things in the topStackView can have transparent backgrounds if you need it that way or another color all together
//            messageInputBar.backgroundColor = messageInputBar.backgroundView.backgroundColor
//
//            messageInputBar.topStackView.layoutIfNeeded()
//            messageInputBar.invalidateIntrinsicContentSize()
            
        }
        
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
    
    func defaultStyle() {
//        let newMessageInputBar = MessageInputBar()
//        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        newMessageInputBar.delegate = self
//        messageInputBar = newMessageInputBar
//        reloadInputViews()
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
//
//    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
//        return { view in
//            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
//            view.alpha = 0.0
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
//                view.layer.transform = CATransform3DIdentity
//                view.alpha = 1.0
//            }, completion: nil)
//        }
//    }
}



// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {

    
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageTop)
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isCurrentSender(message: message) {
            switch message.data {
            case .text(_, _):
                return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 4)
            case .location(_, _, _):
                return UIEdgeInsets(top: 0, left: 40 + 25, bottom: 0, right: 4)
            }
        } else {
            switch message.data {
            case .text(_, _):
                return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 40)
            case .location(_, _, _):
                return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 40 + 25)
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
        return 120 + labelHeight + 8
    }
    
}


// MARK: - MessageCellDelegate

extension ConversationViewController: MessageCellDelegate {

}

// MARK: - MessageLabelDelegate

extension ConversationViewController: MessageLabelDelegate {
    
}


//extension ConversationViewController: MessageInputBarDelegate {
//    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        let id = UUID().uuidString
//        let message = AssistantMessage.init(data: .text(text, nil), sender: MessageFactory.shared.currentSender, id: id, date: Date())
//        messages.append(message)
//        inputBar.inputTextView.text = String()
//        messagesCollectionView.insertSections([messages.count - 1])
//        messagesCollectionView.scrollToBottom()
//    }
//}

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

