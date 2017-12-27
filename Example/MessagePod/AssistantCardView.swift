//
//  AssistantCardView.swift
//  MessagePod_Example
//
//  Created by gang wang on 27/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AssistantCardView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.register(UINib(nibName: "AssistantCardApartmentCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    lazy var footerView: AssistantCardFooterView = {
        let footerView = AssistantCardFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 48))
        footerView.moreActionCallback = { [weak self] in
            self?.moreActionCallback?()
        }
        return footerView
    }()
    
    var items: [Apartment] = [] {
        didSet {
            if items.count >= 2 {
                footerView.isHidden = false
            } else {
                footerView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    var moreActionCallback: (() -> Void)?
    var didSelectedApartmentCallback: ((Apartment) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        
        self.backgroundColor = UIColor.white

        addSubview(self.tableView)
        self.addSubview(footerView)

        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(6)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        if footerView.superview != nil {
            footerView.snp.makeConstraints { make in
                make.bottom.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(48)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension AssistantCardView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(items.count, 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssistantCardApartmentCell
        cell.item = items[indexPath.row]
        return cell
    }
}

extension AssistantCardView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectedApartmentCallback?(items[indexPath.row])
    }
}


class AssistantCardFooterView: UIView {
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        return view
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.init(red: 91.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0), for: UIControlState.normal)
        button.setTitle("更多门店分布 >>", for: UIControlState.normal)
        button.addTarget(self, action: #selector(moreAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var moreActionCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineView)
        addSubview(moreButton)

        self.updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(13)
            make.right.equalTo(self.snp.right).offset(-13)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(0.5)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    @objc func moreAction() {
        moreActionCallback?()
    }
    
}

