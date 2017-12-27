//
//  AssistantCardApartmentCell.swift
//  MessagePod_Example
//
//  Created by gang wang on 27/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AssistantCardApartmentCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var item: Apartment? {
        didSet {
            if let apartment = item {
                let url = URL(string: apartment.imageURL ?? "")
                self.itemImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.2))])
                
                self.itemNameLabel.text = apartment.name
                self.infoLabel.text = String("\(apartment.roomTypeCount)个户型 | \(apartment.minArea ?? "未知")㎡ 起 | \(apartment.roomCount ?? "未知")套房源")
                if apartment.status {
                    if let price = apartment.price {
                        if let price = Double(price), price > 0 {
                            self.priceLabel.text = String(format: "￥%.0f/月起", price)
                        } else {
                            self.priceLabel.text = "已满租"
                        }
                    } else {
                        self.priceLabel.text = "暂无价格"
                    }
                    
                } else {
                    self.priceLabel.text = "即将开业"
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.priceLabel.clipsToBounds = true
        self.priceLabel.layer.cornerRadius = 2
        self.itemImageView.clipsToBounds =  true
        self.itemImageView.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
