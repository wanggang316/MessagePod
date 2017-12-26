//
//  ImageExtension.swift
//  MessagePod
//
//  Created by gang wang on 16/12/2017.
//

import Foundation

extension UIImage {
    public func stretch() -> UIImage {
//        let center = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let capInsets = UIEdgeInsets(top: 24, left: 14, bottom: 10, right: 14)
        return self.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
