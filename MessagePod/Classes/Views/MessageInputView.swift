//
//  MessageInputView.swift
//  MessagePod
//
//  Created by gang wang on 18/12/2017.
//

import UIKit

open class MessageInputView: UIView {

    open weak var delegate: MessageInputViewDelegate?

    
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .inputBarGray
        return view
    }()
    
    open lazy var inputTextView: MessageInputTextView = {
        let textView = MessageInputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageInputView = self
        return textView
    }()
    
    open lazy var taggleButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.addTarget(self, action: #selector(), for: <#T##UIControlEvents#>)
        return button
    }()
    
    
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12) {
        didSet {
            updatePadding()
        }
    }
    
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) {
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

    
    open var maxHeight: CGFloat = UIScreen.main.bounds.height / 3 {
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
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
    
    
    // MARK: - Life
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        backgroundView.addConstraints(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
            ).activate()
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxHeight)
        
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
//        textViewLayoutSet?.bottom?.constant = -padding.bottom
    }
    
    private func updateTextViewPadding() {
        textViewLayoutSet?.left?.constant = textViewPadding.left
        textViewLayoutSet?.right?.constant = -textViewPadding.right
        textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
//        textViewLayoutSet?.top?.constant = textViewPadding.top
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
    
}
