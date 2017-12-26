//
//  InputTipsView.swift
//  MessagePod_Example
//
//  Created by gang wang on 26/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class InputTipsView: UIView {

    // MARK: - UI ELements

    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    
    // MARK: - Properties
    var items: [String] = [] {
        didSet {
            
            for view in self.scrollView.subviews {
                view.removeFromSuperview()
            }
            
            var maxX: CGFloat = 0.0
            let innerSpace: CGFloat = 10.0
            for i in 0..<items.count {
                let tip = items[i]
                let button = tipButton(tip)
                button.frame = CGRect.init(x: maxX + innerSpace, y: 7, width: CGFloat(tip.count * 14 + 16), height: 24)
                maxX = button.frame.maxX
                button.addTarget(self, action: #selector(selectTipAction), for: UIControlEvents.touchUpInside)
                self.scrollView.addSubview(button)
            }
            
            self.scrollView.contentSize = CGSize.init(width: maxX + 10, height: 35)
            self.scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }
    }
    
    func tipButton(_ title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.init(red: 112.0 / 255.0, green: 112.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = .center
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.init(red: 219.0 / 255.0, green: 219.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 11
        button.setTitle(title, for: UIControlState.normal)
        return button
    }
    
    var didSelectedItemCallback: ((String) -> Void)?

    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        addSubview(self.scrollView)


        // constraints
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    @objc func selectTipAction(sender: UIButton) {
        if let title = sender.titleLabel?.text {
            didSelectedItemCallback?(title)
        }
    }
}
