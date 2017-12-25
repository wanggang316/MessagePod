//
//  MessagesCollectionView.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessagesCollectionView: UICollectionView {

    open weak var messagesDataSource: MessagesDataSource?
    
    open weak var messagesDisplayDelegate: MessagesDisplayDelegate?

    open weak var messagesLayoutDelegate: MessagesLayoutDelegate?
    
    open weak var messageCellDelegate: MessageCellDelegate?
    
    open var showsDateHeaderAfterTimeInterval: TimeInterval = 3600

    // MARK: - Initializers
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: MessagesCollectionViewFlowLayout())
    }
    
    public func scrollToBottom(animated: Bool = false) {
        let collectionViewContentHeight = collectionViewLayout.collectionViewContentSize.height
        
        performBatchUpdates(nil) { _ in
            self.scrollRectToVisible(CGRect.init(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
        }
    }
    
    
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
}
