//
//  MessageInputViewDelegate.swift
//  MessagePod
//
//  Created by gang wang on 18/12/2017.
//

import UIKit


/// MessageInputBarDelegate is a protocol that can recieve notifications from the MessageInputBar
public protocol MessageInputViewDelegate: AnyObject {
    
    /// Called when the default send button has been selected
    ///
    /// - Parameters:
    ///   - inputBar: The MessageInputBar
    ///   - text: The current text in the MessageInputBar's InputTextView
    func messageInputView(_ inputView: MessageInputView, didPressSendButtonWith text: String)
    
    /// Called when the instrinsicContentSize of the MessageInputBar has changed. Can be used for adjusting content insets
    /// on other views to make sure the MessageInputBar does not cover up any other view
    ///
    /// - Parameters:
    ///   - inputBar: The MessageInputBar
    ///   - size: The new instrinsicContentSize
    func messageInputView(_ inputView: MessageInputView, didChangeIntrinsicContentTo size: CGSize)
    
    /// Called when the MessageInputBar's InputTextView's text has changed. Useful for adding your own logic without the
    /// need of assigning a delegate or notification
    ///
    /// - Parameters:
    ///   - inputBar: The MessageInputBar
    ///   - text: The current text in the MessageInputBar's InputTextView
    func messageInputView(_ inputView: MessageInputView, textViewTextDidChangeTo text: String)
}

public extension MessageInputViewDelegate {
    
    func messageInputView(_ inputView: MessageInputView, didPressSendButtonWith text: String) {}
    
    func messageInputView(_ inputView: MessageInputView, didChangeIntrinsicContentTo size: CGSize) {}
    
    func messageInputView(_ inputView: MessageInputView, textViewTextDidChangeTo text: String) {}
}
