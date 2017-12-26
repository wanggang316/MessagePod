//
//  MessageInputView.swift
//  MessagePod
//
//  Created by gang wang on 18/12/2017.
//

import UIKit

open class MessageInputView: UIView, UITextViewDelegate {

    open weak var delegate: MessageInputViewDelegate?

    
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    open lazy var inputTextView: MessageInputTextView = {
        let textView = MessageInputTextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageInputView = self
        textView.placeholder = "说点什么..."
        return textView
    }()
    
    
    open lazy var taggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "keyboard"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "voice"), for: UIControlState.selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(taggleAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    open lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("按住说话", for: UIControlState.normal)
        button.setTitleColor(UIColor.init(red: 112.0 / 255.0, green: 112.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0), for: UIControlState.normal)
        button.setTitleColor(UIColor.init(red: 191.0 / 255.0, green: 191.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0), for: UIControlState.highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.init(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(recordAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    open lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    open lazy var topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
        return view
    }()
    
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6 + 36, left: 44, bottom: 6, right: 34) {
        didSet {
            updatePadding()
        }
    }
    
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateTextViewPadding()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != size {
            delegate?.messageInputView(self, didChangeIntrinsicContentTo: size)
            previousIntrinsicContentSize = size
        }
        return size
    }
    
    public private(set) var previousIntrinsicContentSize: CGSize?

    
    open var maxHeight: CGFloat = 100 {
        didSet {
            textViewHeightAnchor?.constant = maxHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    public private(set) var isOverMaxTextViewHeight = false

    
    private var inputBarMinusTextViewHeight: CGFloat {
        return padding.top + textViewPadding.bottom + padding.bottom
    }
    
    // MARK: - Auto-Layout Management
//    private var topViewLayoutSet: NSLayoutConstraintSet?
//    private var topViewHeightAnchor: NSLayoutConstraint?

    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
    
    private var recordButtonLayoutSet: NSLayoutConstraintSet?
    
    private var taggleButtonLayoutSet: NSLayoutConstraintSet?
    
    private var windowAnchor: NSLayoutConstraint?
    
    private var tempInputText: String?
    
    
    // MARK: - Life
    public convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = UIColor.white
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {
        
        autoresizingMask = [.flexibleHeight]
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    /// Adds all of the subviews
    private func setupSubviews() {
        addSubview(backgroundView)
        addSubview(inputTextView)
        addSubview(taggleButton)
        addSubview(recordButton)
        addSubview(topView)
        addSubview(topLineView)
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addConstraints(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)

        // textView
        if #available(iOS 11.0, *) {
            textViewLayoutSet = NSLayoutConstraintSet(
                top:    inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
                bottom: inputTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom),
                left:   inputTextView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left),
                right:  inputTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right)
                ).activate()
        } else {
            textViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
            ).activate()
        }
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxHeight)
       
        
        // recordButton
        recordButtonLayoutSet = NSLayoutConstraintSet(
            top:    recordButton.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
//            bottom: recordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   recordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  recordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
            ).activate()
        recordButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        if #available(iOS 11.0, *) {
            // Switch to safeAreaLayoutGuide
            textViewLayoutSet?.bottom = inputTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
            textViewLayoutSet?.left = inputTextView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left)
            textViewLayoutSet?.right = inputTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right)
        }
        
        
        NSLayoutConstraintSet(
            top:    topView.topAnchor.constraint(equalTo: topAnchor, constant:1),
            bottom: topView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -6),
            left:   topView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            right:  topView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
            ).activate()
        
        NSLayoutConstraintSet(
            top:    topLineView.topAnchor.constraint(equalTo: topAnchor, constant:0),
//            bottom: topLineView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -6),
            left:   topLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            right:  topLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
            ).activate()
        topLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        
        // taggle button
        taggleButtonLayoutSet = NSLayoutConstraintSet(
            bottom: taggleButton.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: -3),
            left:   taggleButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
            ).activate()
        
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        setupConstraints(to: window)
    }
    
    private func setupConstraints(to window: UIWindow?) {
        if #available(iOS 11.0, *) {
            guard UIScreen.main.nativeBounds.height == 2436 else { return }
            if let window = window {
                windowAnchor?.isActive = false
                windowAnchor = inputTextView.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
                windowAnchor?.constant = -padding.bottom
                windowAnchor?.priority = UILayoutPriority(rawValue: 750)
                windowAnchor?.isActive = true
            }
        }
    }
    
    
    /// Adds the required notification observers
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputView.orientationDidChange),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputView.textViewDidChange),
                                               name: .UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputView.textViewDidBeginEditing),
                                               name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputView.textViewDidEndEditing),
                                               name: .UITextViewTextDidEndEditing, object: nil)
    }

    
    open func calculateIntrinsicContentSize() -> CGSize {
        
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        let inputTextViewHeight = inputTextView.sizeThatFits(maxTextViewSize).height.rounded()
        var heightToFit: CGFloat = inputBarMinusTextViewHeight
        
        if inputTextViewHeight >= maxHeight {
            if !isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            heightToFit += maxHeight
        } else {
            if isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = false
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
                inputTextView.invalidateIntrinsicContentSize()
            }
            heightToFit += inputTextViewHeight
        }
        return CGSize(width: bounds.width, height: heightToFit)
    }
    
    
    private func updatePadding() {
        textViewLayoutSet?.top?.constant = padding.top
        textViewLayoutSet?.bottom?.constant = -padding.bottom
        
        recordButtonLayoutSet?.top?.constant = padding.top
//        recordButtonLayoutSet?.bottom?.constant = -padding.bottom
        
        windowAnchor?.constant = -padding.bottom
//        invalidateIntrinsicContentSize()
    }
    
    private func updateTextViewPadding() {
        textViewLayoutSet?.left?.constant = textViewPadding.left
        textViewLayoutSet?.right?.constant = -textViewPadding.right
        textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
    }
    
    
    // MARK: - Notifications/Hooks
    
    /// Invalidates the intrinsicContentSize
    @objc
    open func orientationDidChange() {
        invalidateIntrinsicContentSize()
    }
    

    // MARK: - Action
    @objc
    open func textViewDidChange() {
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        sendButton.isEnabled = !trimmedText.isEmpty
        inputTextView.placeholderLabel.isHidden = !inputTextView.text.isEmpty
        
//        items.forEach { $0.textViewDidChangeAction(with: inputTextView) }
        
        delegate?.messageInputView(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    @objc
    open func textViewDidBeginEditing() {
//        self.items.forEach { $0.keyboardEditingBeginsAction() }
    }
    
    @objc
    open func textViewDidEndEditing() {
//        self.items.forEach { $0.keyboardEditingEndsAction() }
    }
    
    
    @objc func taggleAction(sender: UIButton) {
        
        if sender.isSelected {
            self.inputTextView.resignFirstResponder()
            
            tempInputText = self.inputTextView.text
            self.inputTextView.text = nil
            invalidateIntrinsicContentSize()
            
            self.recordButton.isHidden = false
        } else {
            self.recordButton.isHidden = true
            self.inputTextView.text = tempInputText
            invalidateIntrinsicContentSize()
            
            self.inputTextView.becomeFirstResponder()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @objc func recordAction() {
        
    }
    
    
    
    public func clearInputText() {
        self.inputTextView.text = nil
        self.tempInputText = nil
    }
    
    // MARK: - UITextViewDelegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedText.isEmpty else { return false }
            self.delegate?.messageInputView(self, didPressSendButtonWith: trimmedText)
            self.clearInputText()
            invalidateIntrinsicContentSize()
            return false
        }
        return true
    }
    
}
