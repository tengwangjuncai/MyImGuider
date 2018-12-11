//
//  ScenicPaperCollectionCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/6.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class ScenicPaperCollectionCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImageView.layer.cornerRadius = 5
        self.iconImageView.clipsToBounds = true
        self.bgView.backgroundColor =  kMaskColor
//        self.nameLabel.textColor = UIColor.lightText
    }
    
   func configData(scnice:Scenic){
    
    self.nameLabel.text = scnice.viewname;

    let iconURL = URL(string:scnice.pictures ?? "")!
    self.iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
    }
}
