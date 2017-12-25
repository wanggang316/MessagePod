//
//  MessagesCollectionViewFlowLayout.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties
    open var messageLabelFont: UIFont
    open var topBottomLabelFont: UIFont
    
    open var attributesCacheMaxSize: Int = 500

    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    typealias MessageID = String
    
    fileprivate var intermediateAttributesCache: [MessageID: MessageLayoutAttributes] = [:]

    fileprivate var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("MessagesCollectionViewFlowLayout is being used on a foreign type.")
        }
        return messagesCollectionView
    }
    
    fileprivate var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }
        return messagesDataSource
    }
    
    fileprivate var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError("MessagesLayoutDeleagte has not been set.")
        }
        return messagesLayoutDelegate
    }
    
    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }
    
    // MARK: - Initializers [Public]
    
    public override init() {
        messageLabelFont = UIFont.systemFont(ofSize: 14)
        topBottomLabelFont = UIFont.systemFont(ofSize: 10)
        super.init()
        sectionInset = UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { }
        
    
    // MARK: - Methods [Public]
    
    public func removeCachedAttributes(for message: MessageType) {
        removeCachedAttributes(for: message.id)
    }
    
    public func removeCachedAttributes(for messageId: String) {
        intermediateAttributesCache.removeValue(forKey: messageId)
    }
    
    public func removeAllCachedAttributes() {
        intermediateAttributesCache.removeAll()
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView?.bounds.width != newBounds.width {
            removeAllCachedAttributes()
            return true
        } else {
            return false
        }
    }
    
    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else { return nil }
        
        attributesArray.forEach { attributes in
            if attributes.representedElementCategory == UICollectionElementCategory.cell {
                configure(attributes: attributes)
            }
        }
        
        return attributesArray
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else { return nil }
        
        if attributes.representedElementCategory == UICollectionElementCategory.cell {
            configure(attributes: attributes)
        }
        
        return attributes
        
    }
    
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let attributes = messageIntermediateLayoutAttributes(for: indexPath)
        return CGSize(width: itemWidth, height: attributes.itemHeight)
    }
    
}


fileprivate extension MessagesCollectionViewFlowLayout {
    
    func messageIntermediateLayoutAttributes(for indexPath: IndexPath) -> MessageLayoutAttributes {
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if let intermediateAttributes = intermediateAttributesCache[message.id] {
            return intermediateAttributes
        } else {
            let newAttributes = createMessageIntermediateLayoutAttributes(for: message, at: indexPath)
            
            let shouldCache = messagesLayoutDelegate.shouldCacheLayoutAttributes(for: message) && intermediateAttributesCache.count < attributesCacheMaxSize
            
            if shouldCache {
                intermediateAttributesCache[message.id] = newAttributes
            }
            return newAttributes
        }
        
    }
    

    func createMessageIntermediateLayoutAttributes(for message: MessageType, at indexPath: IndexPath) -> MessageLayoutAttributes {
        
        let attributes = MessageLayoutAttributes(message: message, indexPath: indexPath)
        
        // None of these are dependent on other attributes
        attributes.avatarPosition = avatarPosition(for: attributes)
        attributes.avatarSize = avatarSize(for: attributes)
        attributes.messageContainerPadding = messageContainerPadding(for: attributes)
        attributes.messageLabelInsets = messageLabelInsets(for: attributes)
        
        // MessageContainerView
        attributes.messageContainerMaxWidth = messageContainerMaxWidth(for: attributes)
        attributes.messageContainerSize = messageContainerSize(for: attributes)
        
        // Cell Bottom Label
        attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: attributes)
        attributes.bottomLabelMaxWidth = cellBottomLabelMaxWidth(for: attributes)
        attributes.bottomLabelSize = cellBottomLabelSize(for: attributes)
        
        // Cell Top Label
        attributes.topLabelAlignment = cellTopLabelAlignment(for: attributes)
        attributes.topLabelMaxWidth = cellTopLabelMaxWidth(for: attributes)
        attributes.topLabelSize = cellTopLabelSize(for: attributes)
        
        // Cell Height
        attributes.itemHeight = cellHeight(for: attributes)
        
        return attributes
    }
    
    
    
    private func configure(attributes: MessagesCollectionViewLayoutAttributes) {
        
        let intermediateAttributes = messageIntermediateLayoutAttributes(for: attributes.indexPath)
        
        intermediateAttributes.cellFrame = attributes.frame
        
        attributes.messageContainerFrame = intermediateAttributes.messageContainerFrame
        attributes.topLabelFrame = intermediateAttributes.topLabelFrame
        attributes.bottomLabelFrame = intermediateAttributes.bottomLabelFrame
        attributes.avatarFrame = intermediateAttributes.avatarFrame
        attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
        
        switch intermediateAttributes.message.data {
//        case .emoji:
//            attributes.messageLabelFont = emojiLabelFont
        case .text:
            attributes.messageLabelFont = messageLabelFont
//        case .attributedText(let text):
//            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
//            attributes.messageLabelFont = font
        default:
            break
        }
        
    }
}


// MARK: - Avatar

fileprivate extension MessagesCollectionViewFlowLayout {
    
    func avatarPosition(for attributes: MessageLayoutAttributes) -> AvatarPosition {
        var position = messagesLayoutDelegate.avatarPosition(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)

        switch position.horizontal {
        case .cellLeading, .cellTrailing:
            break
        case .natural:
            position.horizontal = messagesDataSource.isCurrentSender(message: attributes.message) ? .cellTrailing : .cellLeading
        }
        
        return position
    }
    
    func avatarSize(for attributes: MessageLayoutAttributes) -> CGSize {
        return messagesLayoutDelegate.avatarSize(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
}


private extension MessagesCollectionViewFlowLayout {
    
    func labelSize(for text: String, considering maxWidth: CGFloat, and font: UIFont) -> CGSize {
     
        let estimatedHeight = text.height(considering: maxWidth, and: font)
        let estimatedWidth = text.width(considering: estimatedHeight, and: font)
        
        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
}


// MARK: - MessageContainer
private extension MessagesCollectionViewFlowLayout {
    
    func messageContainerPadding(for attributes: MessageLayoutAttributes) -> UIEdgeInsets {
        return messagesLayoutDelegate.messagePadding(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    func messageLabelInsets(for attributes: MessageLayoutAttributes) -> UIEdgeInsets {
        return messagesLayoutDelegate.messageLabelInset(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    func messageContainerMaxWidth(for attributes: MessageLayoutAttributes) -> CGFloat {
        switch attributes.message.data {
        case .text(_, _):
            return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding - attributes.messageLabelHorizontalInsets
        case .location(_, _, _):
             return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding
        }
    }
    
    func messageContainerSize(for attributes: MessageLayoutAttributes) -> CGSize {
        
        let message = attributes.message
        let indexPath = attributes.indexPath
        let maxWidth = attributes.messageContainerMaxWidth
        
        var messageContainerSize: CGSize = .zero

        switch attributes.message.data {
        case .text(let text, _):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: messageLabelFont)
            messageContainerSize.width += attributes.messageLabelHorizontalInsets
            messageContainerSize.height += attributes.messageLabelVerticalInsets
        case .location(_, _, _):
            let width = messagesLayoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        }
        return messageContainerSize
    }
}


private extension MessagesCollectionViewFlowLayout {
    func cellBottomLabelAlignment(for attributes: MessageLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellBottomLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    func cellBottomLabelMaxWidth(for attributes: MessageLayoutAttributes) -> CGFloat {
        
        let labelHorizontal = attributes.bottomLabelAlignment
        let avatarHorizontal = attributes.avatarPosition.horizontal
        let avatarVertical = attributes.avatarPosition.vertical
        let avatarWidth = attributes.avatarSize.width
        
        switch (labelHorizontal, avatarHorizontal) {
            
        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - attributes.bottomLabelHorizontalPadding
            return avatarVertical != .cellBottom ? width : width - avatarWidth
            
        case (.cellCenter, _):
            let width = itemWidth - attributes.bottomLabelHorizontalPadding
            return avatarVertical != .cellBottom ? width : width - (avatarWidth * 2)
            
        case (.messageTrailing, .cellLeading):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.left - attributes.bottomLabelHorizontalPadding
            return avatarVertical == .cellBottom ? width : width + avatarWidth
            
        case (.messageLeading, .cellTrailing):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.right - attributes.bottomLabelHorizontalPadding
            return avatarVertical == .cellBottom ? width : width + avatarWidth
            
        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.left - attributes.bottomLabelHorizontalPadding
            
        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.right - attributes.bottomLabelHorizontalPadding
            
        case (_, .natural):
            fatalError("AvatarPosition Horizontal.natural needs to be resolved.")
        }
    }
    
    
    func cellBottomLabelSize(for attributes: MessageLayoutAttributes) -> CGSize {
        
        let text = messagesDataSource.cellBottomLabelText(for: attributes.message, at: attributes.indexPath)
        
        guard let bottomLabelText = text else { return .zero }
        return labelSize(for: bottomLabelText, considering: attributes.bottomLabelMaxWidth, and: topBottomLabelFont)
    }
}

private extension MessagesCollectionViewFlowLayout {
    func cellTopLabelAlignment(for attributes: MessageLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellTopLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    func cellTopLabelMaxWidth(for attributes: MessageLayoutAttributes) -> CGFloat {
        
        let labelHorizontal = attributes.topLabelAlignment
        let avatarHorizontal = attributes.avatarPosition.horizontal
        let avatarVertical = attributes.avatarPosition.vertical
        let avatarWidth = attributes.avatarSize.width
        
        switch (labelHorizontal, avatarHorizontal) {
            
        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - attributes.topLabelHorizontalPadding
            return avatarVertical != .cellTop ? width : width - avatarWidth
            
        case (.cellCenter, _):
            let width = itemWidth - attributes.topLabelHorizontalPadding
            return avatarVertical != .cellTop ? width : width - (avatarWidth * 2)
            
        case (.messageTrailing, .cellLeading):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.left - attributes.topLabelHorizontalPadding
            return avatarVertical == .cellTop ? width : width + avatarWidth
            
        case (.messageLeading, .cellTrailing):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.right - attributes.topLabelHorizontalPadding
            return avatarVertical == .cellTop ? width : width + avatarWidth
            
        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.left - attributes.topLabelHorizontalPadding
            
        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.right - attributes.topLabelHorizontalPadding
            
        case (_, .natural):
            fatalError("AvatarPosition Horizontal.natural needs to be resolved.")
        }
        
    }
    
    
    func cellTopLabelSize(for attributes: MessageLayoutAttributes) -> CGSize {
        let text = messagesDataSource.cellTopLabelText(for: attributes.message, at: attributes.indexPath)
        guard let topLabelText = text else { return .zero }
        return labelSize(for: topLabelText, considering: attributes.topLabelMaxWidth, and: topBottomLabelFont)
    }
}


private extension MessagesCollectionViewFlowLayout {
    private func cellHeight(for attributes: MessageLayoutAttributes) -> CGFloat {
        var cellHeight: CGFloat = 0
        switch attributes.avatarPosition.vertical {
        case .cellTop:
            cellHeight += max(attributes.avatarSize.height, attributes.topLabelSize.height)
            cellHeight += attributes.bottomLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .cellBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.bottomLabelSize.height)
            cellHeight += attributes.topLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.messageContainerSize.height)
            cellHeight += attributes.messageVerticalPadding
            cellHeight += attributes.topLabelSize.height
            cellHeight += attributes.bottomLabelSize.height
        }
        return cellHeight
    }
}



