//
//  MessageViewController.swift
//  MessageUI
//
//  Created by gang wang on 12/12/2017.
//

import UIKit

open class MessageViewController: UIViewController {

    // MARK: - UI Elements
    
    open var messagesTableView = MessageTableView()
    open var messageCellLayout: MessageCellLayout = MessageCellLayout()
    
    open var sender: Sender = Sender.init(id: "2", name: "", image: UIImage.init())
    
    lazy var outBubbleImage: UIImage = {
        var name = "bubble_out@2x"
        let path = Bundle.imagePath(for: name)!
        return UIImage.init(contentsOfFile: path)!.stretch()
    }()
    
    lazy var inBubbleImage: UIImage = {
        var name = "bubble_in@2x"
        let path = Bundle.imagePath(for: name)!
        return UIImage.init(contentsOfFile: path)!.stretch()
    }()
    
    lazy var outAvatarPosition: AvatarPosition = AvatarPosition.init(side: .cellTrailing, margin: UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 10))
    lazy var inAvatarPosition: AvatarPosition = AvatarPosition.init(side: .cellLeading, margin: UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 0))

    // MARK: - Properties
    open var messages: [Message]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.messageDataSource = self
        self.messagesTableView.messageDelegate = self
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        self.messagesTableView.tableFooterView = UIView()
        self.messagesTableView.separatorStyle = .none
        
        self.messageCellLayout.messageTableView = self.messagesTableView

        self.view.addSubview(self.messagesTableView)
        
        self.messagesTableView.register(MessageTextCell.self, forCellReuseIdentifier: "cell")
        self.setupConstraints()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupConstraints() {
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = messagesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let bottom = messagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            let leading = messagesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = messagesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        } else {
            let leading = messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        }
        adjustScrollViewInset()
    }
    
    @objc
    private func adjustScrollViewInset() {
        if #available(iOS 11.0, *) {
            // No need to add to the top contentInset
        } else {
            let navigationBarInset = navigationController?.navigationBar.frame.height ?? 0
            let statusBarInset: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : 20
            let topInset = navigationBarInset + statusBarInset
            messagesTableView.contentInset.top = topInset
            messagesTableView.scrollIndicatorInsets.top = topInset
        }
    }
}

extension MessageViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTextCell
        if let message = self.messagesTableView.messageDataSource?.messageForItem(at: indexPath, in: self.messagesTableView) {
            cell.configCell(with: message,
                     attributes: self.messageCellLayout.messageCellLayoutAttributes(for: indexPath),
                    bubbleImage: (self.messagesTableView.messageDataSource?.bubbleImage(for: message, in: messagesTableView))!)
        }
        return cell
    }
}

extension MessageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attributes = self.messageCellLayout.messageCellLayoutAttributes(for: indexPath)
        return attributes.itemHeight
    }

}


extension MessageViewController: MessageViewDataSource {
    
    public func currentSender() -> Sender {
        return self.sender
    }
    
    public func numberofRows(in messageTableView: MessageTableView) -> Int {
        return self.messages?.count ?? 0
    }

    public func messageForItem(at indexPath: IndexPath, in messageTableView: MessageTableView) -> Message? {
        return self.messages?[indexPath.row] ?? nil
    }

    public func bubbleImage(for message: Message, in messageTableView: MessageTableView) -> UIImage? {
        if isCurrentSender(message: message) {
            return outBubbleImage
        } else {
            return inBubbleImage
        }
    }
}

extension MessageViewController: MessageViewDelegate {
//    public func height(of indexPath: IndexPath) -> CGFloat {
//        return self.messageCellLayout.messageCellLayoutAttributes(for: indexPath)
//    }

    // MARK: - layout
    
    /// - cell
    public func messageCellWidth(at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// - message label
    public func messagePadding(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets {
        if sender == message.sender {
            return UIEdgeInsets.init(top: 15, left: 60, bottom: 15, right: 10)
        } else {
            return UIEdgeInsets.init(top: 15, left: 10, bottom: 15, right: 60)
        }
    }
    public func messageLabelInset(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    /// - avatar
    public func avatarPosition(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> AvatarPosition {
        if sender == message.sender {
            return outAvatarPosition// AvatarPosition.init(side: .cellTrailing, margin: UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 10))
        } else {
            return inAvatarPosition// AvatarPosition.init(side: .cellLeading, margin: UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 0))
        }
    }
    public func avatarSize(for message: Message, at indexPath: IndexPath, in messageTableView: MessageTableView) -> CGSize {
        return CGSize.init(width: 34, height: 34)
    }

}
