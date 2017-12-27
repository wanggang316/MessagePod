//
//  StringExtension.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

public extension String {
    
    public func height(considering width: CGFloat, and font: UIFont) -> CGFloat {
        
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.height
        
    }
    
    public func width(considering height: CGFloat, and font: UIFont) -> CGFloat {
        
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        let rect = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.width
        
    }
}
