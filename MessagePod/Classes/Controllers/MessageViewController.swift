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
    open var messageInputView = MessageInputView()

    
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

    // MARK: - input view
    open override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open var scrollsToBottomOnKeybordBeginsEditing: Bool = false

    open var scrollsToBottomOnFirstLayout: Bool = false

    
    private var isFirstLayout: Bool = true

    
    // MARK: - Properties
    open var messages: [Message]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        messagesTableView.keyboardDismissMode = .interactive
        messagesTableView.alwaysBounceVertical = true

        
        self.messagesTableView.messageDataSource = self
        self.messagesTableView.messageDelegate = self
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        self.messagesTableView.tableFooterView = UIView()
        self.messagesTableView.separatorStyle = .none
        
        self.messageCellLayout.messageTableView = self.messagesTableView

        self.view.addSubview(self.messagesTableView)
        
//        scrollsToBottomOnFirstLayout = true //default false
//        scrollsToBottomOnKeybordBeginsEditing = true // default false
        
        let newMessageInputView = MessageInputView()
//        newMessageInputView.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputView.delegate = self
        messageInputView = newMessageInputView
        reloadInputViews()
        
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
//            let navigationBarInset = navigationController?.navigationBar.frame.height ?? 0
//            let statusBarInset: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : 20
//            let topInset = navigationBarInset + statusBarInset
//            messagesTableView.contentInset.top = topInset
//            messagesTableView.scrollIndicatorInsets.top = topInset
        }
    }
    
    
    
    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            
            addKeyboardObservers()
            messagesTableView.contentInset.bottom = keyboardOffsetFrame.height
            messagesTableView.scrollIndicatorInsets.bottom = keyboardOffsetFrame.height
            
            //Scroll to bottom at first load
            if scrollsToBottomOnFirstLayout {
                messagesTableView.setContentOffset(CGPoint.init(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
            }
        }
    }
    
    // MARK: - Initializers
    
    deinit {
        removeKeyboardObservers()
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



// MARK: - Keyboard Handling

fileprivate extension MessageViewController {
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidBeginEditing), name: .UITextViewTextDidBeginEditing, object: messageInputView.inputTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollViewInset), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidBeginEditing, object: messageInputView.inputTextView)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc
    func handleTextViewDidBeginEditing(_ notification: Notification) {
        if scrollsToBottomOnKeybordBeginsEditing {
            messagesTableView.setContentOffset(CGPoint.init(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
        }
    }
    
    @objc
    func handleKeyboardDidChangeState(_ notification: Notification) {
        
        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > UIScreen.main.bounds.height {
            // Hardware keyboard is found
            let bottomInset = view.frame.size.height - keyboardEndFrame.origin.y - iPhoneXBottomInset
            messagesTableView.contentInset.bottom = bottomInset
            messagesTableView.scrollIndicatorInsets.bottom = bottomInset
            
        } else {
            //Software keyboard is found
            let bottomInset = keyboardEndFrame.height > keyboardOffsetFrame.height ? (keyboardEndFrame.height - iPhoneXBottomInset) : keyboardOffsetFrame.height
            messagesTableView.contentInset.bottom = bottomInset
            messagesTableView.scrollIndicatorInsets.bottom = bottomInset
        }
        
    }
    
    fileprivate var keyboardOffsetFrame: CGRect {
        guard let inputFrame = inputAccessoryView?.frame else { return .zero }
        return CGRect(origin: inputFrame.origin, size: CGSize(width: inputFrame.width, height: inputFrame.height - iPhoneXBottomInset))
    }
    
    /// On the iPhone X the inputAccessoryView is anchored to the layoutMarginesGuide.bottom anchor so the frame of the inputAccessoryView
    /// is larger than the required offset for the MessagesCollectionView
    ///
    /// - Returns: The safeAreaInsets.bottom if its an iPhoneX, else 0
    fileprivate var iPhoneXBottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            guard UIScreen.main.nativeBounds.height == 2436 else { return 0 }
            return view.safeAreaInsets.bottom
        }
        return 0
    }
}

// MARK: - MessageInputBarDelegate

extension MessageViewController: MessageInputViewDelegate {
    
    public func messageInputView(_ inputView: MessageInputView, didPressSendButtonWith text: String) {
//        messageList.append(MockMessage(text: text, sender: currentSender(), messageId: UUID().uuidString, date: Date()))
//        inputBar.inputTextView.text = String()
//        messagesCollectionView.insertSections([messageList.count - 1])
//        messagesCollectionView.scrollToBottom()
    }
    
    public func messageInputView(_ inputView: MessageInputView, textViewTextDidChangeTo text: String) {
        print(text)
    }
}

extension MessageViewController: MessageInputBarDelegate {
    
    public func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        messageList.append(MockMessage(text: text, sender: currentSender(), messageId: UUID().uuidString, date: Date()))
//        inputBar.inputTextView.text = String()
//        messagesCollectionView.insertSections([messageList.count - 1])
//        messagesCollectionView.scrollToBottom()
    }
    
}

