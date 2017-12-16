//
//  AttributeStringExtension.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

extension NSAttributedString {
    func height(considering width: CGFloat) -> CGFloat {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, context: nil)
        return rect.height
    }
}
