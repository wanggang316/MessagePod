//
//  CustomCardMessageCell.swift
//  MessagePod_Example
//
//  Created by gang wang on 27/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MessagePod

class CustomCardMessageCell: MessageCollectionViewCell {

    open override class func reuseIdentifier() -> String {
        return "com.messagepod.cell.customcard"
    }
    
    lazy var cardView: AssistantCardView = {
        let cardView = AssistantCardView()
        
        cardView.didSelectedApartmentCallback = { [weak self] apartment in
            print("--- didselect \(apartment)")
        }
        cardView.moreActionCallback = {
            print("--- didselect more ...")
        }
        return cardView
    }()
    
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(cardView)
        setupConstraints()
    }
    
    open func setupConstraints() {
        cardView.fillSuperview()
    }
    
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
//        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
//            fatalError("MessagesDisplayDelegate not set.")
//        }
        
        switch message.data {
        case .custom(let data):
            if let apartments = data as? [Apartment] {
                cardView.items = apartments
            }
        default:
            break
        }
    }

}
