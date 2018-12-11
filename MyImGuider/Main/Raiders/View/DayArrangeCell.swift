//
//  DayArrangeCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/20.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class DayArrangeCell: UITableViewCell {

    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var actionNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var isHideCityView : Bool? {
        
        didSet{
           cityView.isHidden = isHideCityView ?? true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cityImageView.layer.cornerRadius = 25
        self.cityImageView.clipsToBounds = true
        
        self.bgView.layer.cornerRadius = 5
        self.bgView.clipsToBounds = true
        
        self.contentView.backgroundColor = kThemeBgColor
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
