//
//  CityTourCCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 4/9/19.
//  Copyright © 2019 王鹏宇. All rights reserved.
//

import UIKit

class CityTourCCell: UICollectionViewCell {

    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityTourImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.superView.layer.cornerRadius = 8
        self.superView.clipsToBounds = true
    }
    
    
    func configData(line:LineModel) {
        
        self.titleLabel.text = line.linename
        
        let picArray:[String] = (line.pictures?.components(separatedBy: ","))!
        let iconUrl = URL(string: picArray.first ?? "")
        self.cityTourImageView.kf.setImage(with: iconUrl, placeholder: kPlaceholdRec, options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let dd = "\(line.recordcount ?? 0)"
        if line.recordcount != 0 {
            let str : NSMutableAttributedString = NSMutableAttributedString(string: "\(dd)个讲解")
            
            str.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: dd.count))
            
            self.countLabel.attributedText = str
        }
        
    }

}
