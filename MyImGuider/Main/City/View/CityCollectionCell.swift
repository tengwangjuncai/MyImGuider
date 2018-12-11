//
//  CityCollectionCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/3.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit
import Kingfisher

class CityCollectionCell: BasePageCollectionCell {
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var BackgroundImageView: UIImageView!
    
    var city : CityModel?{
        
        didSet{
            self.cityNameLabel.text = city?.city
            let iconURL = URL(string:city?.pictures ?? "")!
            self.BackgroundImageView.kf.setImage(with:iconURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        cityNameLabel.layer.shadowRadius = 2
        cityNameLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        cityNameLabel.layer.shadowOpacity = 0.2
        cityNameLabel.layer.shadowColor = UIColor.black.cgColor
    }
    
    
}
