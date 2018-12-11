//
//  CityLineCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/7.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class CityLineCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var ScenicImageView: UIImageView!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var lineNameLabel: UILabel!
    
    @IBOutlet weak var transporImageView: UIImageView!
    
    @IBOutlet weak var allView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.allView.layer.cornerRadius = 5
        self.allView.clipsToBounds  = true
        
        self.headImageView.layer.cornerRadius = 20
        self.headImageView.clipsToBounds = true
        
        self.headImageView.layer.borderColor = kContentColor.cgColor
        self.headImageView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(line:LineModel) {
        
        self.lineNameLabel.text = line.linename
        
        let picArray:[String] = (line.pictures?.components(separatedBy: ","))!
        let iconUrl = URL(string: picArray.first ?? "")
        self.ScenicImageView.kf.setImage(with: iconUrl, placeholder: kPlaceholdRec, options: nil, progressBlock: nil, completionHandler: nil)
        
        let headUrl = URL(string: line.guide?.headimg ?? "")
        self.headImageView.kf.setImage(with: headUrl, placeholder:kPlaceholdIcon, options: nil, progressBlock: nil, completionHandler: nil)
        
        let dd = "\(line.recordcount ?? 0)"
        if line.recordcount != 0 {
            let str : NSMutableAttributedString = NSMutableAttributedString(string: "\(dd)个讲解")
            
            str.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: dd.count))
            
            self.numLabel.attributedText = str
        }
        
    }
    
    
}
