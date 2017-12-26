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
        view.backgroundColor = .red
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
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(taggleAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    open lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("按住说话", for: UIControlState.normal)
        button.setTitleColor(UIColor.init(red: 191.0 / 255.0, green: 191.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.brown
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
        view.backgroundColor = UIColor.blue
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
    private var topViewHeightAnchor: NSLayoutConstraint?

    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
    
    private var taggleButtonLayoutSet: NSLayoutConstraintSet?
    
    
    private var tempInputText: String?
    
    
    // MARK: - Life
    public convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = UIColor.yellow
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
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
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addConstraints(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)


//        topView.heightAnchor.constraint(equalToConstant: 36)
        NSLayoutConstraintSet(
            top:    topView.topAnchor.constraint(equalTo: topAnchor, constant:0),
            bottom: topView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -6),
            left:   topView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            right:  topView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
            ).activate()
        
        // textView
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
            ).activate()
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxHeight)
        
        // recordButton
        NSLayoutConstraintSet(
            top:    recordButton.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
//            bottom: recordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   recordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  recordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
            ).activate()
        topViewHeightAnchor = recordButton.heightAnchor.constraint(equalToConstant: 34)
        topViewHeightAnchor?.isActive = true
        
        // taggle button
        taggleButtonLayoutSet = NSLayoutConstraintSet(
            bottom: taggleButton.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: -3),
            left:   taggleButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
            ).activate()
        
       
        
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            guard let window = window else { return }

            textViewLayoutSet?.bottom?.isActive = false
            textViewLayoutSet?.bottom = inputTextView.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
            textViewLayoutSet?.bottom?.isActive = true

//            textViewLayoutSet?.bottom?.isActive = true
//            textViewLayoutSet?.bottom?.isActive = true
//            textViewLayoutSet?.activate()
            // bottomAnchor must be set to the window to avoid a memory leak issue
//            bottomStackViewLayoutSet?.bottom?.isActive = false
//            bottomStackViewLayoutSet?.bottom = bottomStackView.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
//            bottomStackViewLayoutSet?.bottom?.isActive = true
        }
    }
    
//    internal func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
//        
//        textViewLayoutSet?.deactivate()
////        leftStackViewLayoutSet?.deactivate()
////        rightStackViewLayoutSet?.deactivate()
////        bottomStackViewLayoutSet?.deactivate()
////        topStackViewLayoutSet?.deactivate()
//        if animated {
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.3, animations: animations)
//            }
//        } else {
//            UIView.performWithoutAnimation { animations() }
//        }
//        textViewLayoutSet?.activate()
////        leftStackViewLayoutSet?.activate()
////        rightStackViewLayoutSet?.activate()
////        bottomStackViewLayoutSet?.activate()
////        topStackViewLayoutSet?.activate()
//    }
    
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
