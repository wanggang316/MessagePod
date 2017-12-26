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
    private lazy var itemCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(InputTipCell.self, forCellWithReuseIdentifier: "InputTipCell")
        view.backgroundColor = UIColor.orange
        view.alwaysBounceVertical = false
        view.isScrollEnabled = false
        return view
    }()
    
    
    // MARK: - Properties
    var items: [String] = [] {
        didSet {
            itemCollectionView.reloadData()
        }
    }
    
    var didSelectedItemCallback: ((String) -> Void)?

    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.red
        addSubview(itemCollectionView)
        
        translatesAutoresizingMaskIntoConstraints = false
        // constraints
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        self.itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalTo(self)
            make.height.equalTo(60)
        }
        
//        itemCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        itemCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        itemCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        itemCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
////        itemCollectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.itemCollectionView.frame = self.bounds

    }
    
}





extension InputTipsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputTipCell", for: indexPath) as! InputTipCell
        cell.item = self.items[indexPath.item]
        return cell
    }
    
}

extension InputTipsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        self.didSelectedItemCallback?(item)
    }
}

extension InputTipsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
}



class InputTipCell: UICollectionViewCell {
    
    // MARK: - UI Element
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    var item: String? {
        didSet {
            if let item = self.item {
                self.titleLabel.text = item
            }
        }
    }
    
    // MARK: - Life
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.titleLabel)
        
        // constraint
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
