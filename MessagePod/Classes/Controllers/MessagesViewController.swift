//
//  MessagesViewController.swift
//  MessageUI
//
//  Created by gang wang on 12/12/2017.
//

import UIKit

open class MessagesViewController: UIViewController {

    // MARK: - UI Elements
    
    open var messagesCollectionView = MessagesCollectionView()
    
    open var messageInputBar = MessageInputBar()

//    open var sender: Sender = Sender.init(id: "2", name: "", image: UIImage.init())
    
    // MARK: - input view
    open override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    // MARK: - Constraint
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open var scrollsToBottomOnKeybordBeginsEditing: Bool = true
    
    open var maintainPositionOnKeyboardFrameChanged: Bool = true

    open var scrollsToBottomOnFirstLayout: Bool = true

    private var isFirstLayout: Bool = true

    private var messageCollectionViewBottomInset: CGFloat = 0 {
        didSet {
            messagesCollectionView.contentInset.bottom = messageCollectionViewBottomInset
            messagesCollectionView.scrollIndicatorInsets.bottom = messageCollectionViewBottomInset
        }
    }
    
    // MARK: - Properties
//    open var messages: [MessageType]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.alwaysBounceVertical = true
        
        setupSubviews()
        setupConstraints()
        registerReusableViews()
        setupDelegates()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            messageCollectionViewBottomInset = keyboardOffsetFrame.height
        }
    }
    
    // MARK: - Initializers
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - Methods [Private]
    
    /// Sets the delegate and dataSource of the messagesCollectionView property.
    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }
    
    /// Registers all cells and supplementary views of the messagesCollectionView property.
    private func registerReusableViews() {
        
        messagesCollectionView.register(TextMessageCell.self)
//        messagesCollectionView.register(MediaMessageCell.self)
//        messagesCollectionView.register(LocationMessageCell.self)
        
//        messagesCollectionView.register(MessageFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
//        messagesCollectionView.register(MessageHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
//        messagesCollectionView.register(MessageDateHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
        
    }
    
    /// Adds the messagesCollectionView to the controllers root view.
    private func setupSubviews() {
        view.addSubview(messagesCollectionView)
    }
    
    /// Sets the constraints of the `MessagesCollectionView`.
    private func setupConstraints() {
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let bottom = messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        } else {
            let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            messagesCollectionView.contentInset.top = topInset
            messagesCollectionView.scrollIndicatorInsets.top = topInset
        }
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return messagesLayoutDelegate.headerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return messagesLayoutDelegate.footerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }
}

extension MessagesViewController: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }
        
        // Each message is its own section
        return collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }
        
        let messageCount = collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
        // There will only ever be 1 message per section
        return messageCount > 0 ? 1 : 0
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("Managed collectionView: \(collectionView.debugDescription) is not a MessagesCollectionView.")
        }
        
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate has not been set.")
        }
        
        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            return displayDelegate.messageHeaderView(for: message, at: indexPath, in: messagesCollectionView)
        case UICollectionElementKindSectionFooter:
            return displayDelegate.messageFooterView(for: message, at: indexPath, in: messagesCollectionView)
        default:
            fatalError("Unrecognized element of kind: \(kind)")
        }
    }
}





// MARK: - Keyboard Handling

fileprivate extension MessagesViewController {
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidBeginEditing), name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollViewInset), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc
    func handleTextViewDidBeginEditing(_ notification: Notification) {
        if scrollsToBottomOnKeybordBeginsEditing {
            guard let inputTextView = notification.object as? InputTextView, inputTextView === messageInputBar.inputTextView else { return }
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    @objc
    func handleKeyboardDidChangeState(_ notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > UIScreen.main.bounds.height {
            // Hardware keyboard is found
            messageCollectionViewBottomInset = view.frame.size.height - keyboardEndFrame.origin.y - iPhoneXBottomInset
        } else {
            //Software keyboard is found
            let afterBottomInset = keyboardEndFrame.height > keyboardOffsetFrame.height ? (keyboardEndFrame.height - iPhoneXBottomInset) : keyboardOffsetFrame.height
            let differenceOfBottomInset = afterBottomInset - messageCollectionViewBottomInset
            let contentOffset = CGPoint(x: messagesCollectionView.contentOffset.x, y: messagesCollectionView.contentOffset.y + differenceOfBottomInset)
            
            if maintainPositionOnKeyboardFrameChanged {
                messagesCollectionView.setContentOffset(contentOffset, animated: false)
            }
            
            messageCollectionViewBottomInset = afterBottomInset
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


