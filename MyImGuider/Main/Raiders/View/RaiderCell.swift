//
//  RaiderCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 4/9/19.
//  Copyright © 2019 王鹏宇. All rights reserved.
//

import UIKit

class RaiderCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var raiderImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
//        cardView.backgroundColor = UIColor.green
        
        self.addShadow(type: .card)
        headImageView.addShadow(type: .btn)
        
        headImageView.layer.cornerRadius = 18
        headImageView.clipsToBounds = true
        
    }
    
    func configData(raider:RaiderModel){
        
        titleLabel.text = raider.title
        raiderImageView.kf.setImage(with: URL(string: raider.pictures ?? ""), placeholder: UIImage(named: "placeholder_squ"), options: nil, progressBlock: nil, completionHandler: nil)
        
        headImageView.kf.setImage(with: URL(string: raider.guideheadimg ?? ""),placeholder: UIImage(named: "default"), options: nil, progressBlock: nil, completionHandler: nil)
        
    }

}
