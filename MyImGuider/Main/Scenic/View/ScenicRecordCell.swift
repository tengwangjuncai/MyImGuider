//
//  ScenicRecordCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/11.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class ScenicRecordCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var guideNameLabel: UILabel!
    @IBOutlet weak var recordNameLabel: UILabel!
    
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var visitLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    
    var lineModel : LineModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.headerImageView.layer.cornerRadius = 30
        self.headerImageView.clipsToBounds = true
        self.headerImageView.layer.borderColor = kContentColor.cgColor
        self.headerImageView.layer.borderWidth = 0.5
        
        self.backgroundColor = kThemeBgColor
        self.contentView.backgroundColor = kThemeBgColor
        self.recordNameLabel.textColor = kTitleColor
        self.recordCountLabel.textColor = kContentColor
        self.timeLabel.textColor = kContentColor
        self.visitLabel.textColor = kContentColor
        self.descLabel.textColor = kContentColor
        
        self.tag1Label.textColor = KThemeColor
        self.tag2Label.textColor = KThemeColor
        self.tag1Label.layer.borderColor = KThemeColor.cgColor
        self.tag2Label.layer.borderColor = KThemeColor.cgColor
        self.tag1Label.layer.borderWidth = 0.5
        self.tag2Label.layer.borderWidth = 0.5
        self.tag1Label.isHidden = true
        self.tag2Label.isHidden = true
        self.tag1Label.layer.cornerRadius = 6
        self.tag2Label.layer.cornerRadius = 6
        self.tag1Label.clipsToBounds = true
        self.tag2Label.clipsToBounds = true
        self.descHeight.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(lineModel:LineModel){
        
        self.lineModel = lineModel
        self.recordNameLabel.text = lineModel.linename
//        self.guideNameLabel.text = lineModel.guide?.realname
        self.recordCountLabel.text = "\(lineModel.recordcount ?? 6)"
        if (lineModel.timelabel?.count)! > 0 {
            self.timeLabel.text = (lineModel.timelabel ?? "") + "min"
        }
        self.visitLabel.text = "\(lineModel.visits ?? 66)"
        
        let headUrl = URL(string: lineModel.guide?.headimg ?? "")
        self.headerImageView.kf.setImage(with: headUrl, placeholder:kPlaceholdIcon, options: nil, progressBlock: nil, completionHandler: nil)
        
        let str = lineModel.linedesc ?? ""
        self.descLabel.text = str
        
//        let whitespace = NSCharacterSet.whitespacesAndNewlines
//        str =  str.trimmingCharacters(in: whitespace)
        
        if str != "" {
            self.descHeight.constant = 39
        }else {
            self.descHeight.constant = 0
        }
        
        let arr = lineModel.labels?.components(separatedBy: ",")
        if arr?.count == 2 {
            self.tag1Label.text = arr?.first
            self.tag2Label.text = arr?.last
            self.tag1Label.isHidden = false
            self.tag2Label.isHidden = false
        }else if arr?.count == 1 {
            self.tag1Label.text = arr?.first
            self.tag1Label.isHidden = false
            self.tag2Label.isHidden = true
        }else {
            self.tag1Label.isHidden = true
            self.tag2Label.isHidden = true
        }
    }
   
    @IBAction func playBtnClicked(_ sender: UIButton) {
        
        if  WPY_AVPlayer.playManager.isPlay{
            
            WPY_AVPlayer.playManager.pause()
            sender.setBackgroundImage(UIImage(named: "scenic_Tryplay"), for: UIControlState.normal)
        }else {
            if WPY_AVPlayer.playManager.currentUrl == self.lineModel?.playpath {
                WPY_AVPlayer.playManager.play()
            }else {
                WPY_AVPlayer.playManager.playMusic(url: self.lineModel?.playpath ?? "", type: WPY_AVPlayerType.PlayTypeTry)
            }
            sender.setBackgroundImage(UIImage(named: "scenic_Trypause"), for: UIControlState.normal)
        }
        
    }
    
    
    
}


