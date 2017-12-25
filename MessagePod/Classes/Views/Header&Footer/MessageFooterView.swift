//
//  MessageFooterView.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import UIKit

open class MessageFooterView: UICollectionReusableView, CollectionViewReusable {
    open class func reuseIdentifier() -> String {
        return "com.messagepod.footer.base"
    }
    
    // MARK: - Properties
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
