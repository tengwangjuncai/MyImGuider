//
//  GuiderCardView.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/12.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

protocol GuiderCardViewDelegate : class {
    
    func goGuiderVC(guider:GuideModel)
}

class GuiderCardView: UIView {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var officalLabel: UILabel!
    @IBOutlet weak var vipIcon: UIImageView!
    @IBOutlet weak var vipView: UIView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    var guiderModel : GuideModel?
    weak var delegate : GuiderCardViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goGuiderDetailVC))
        self.addGestureRecognizer(tap)
//        self.backgroundColor = UIColor(red: 84/255.0, green: 119/255.0, blue: 145/255.0, alpha: 1)
    }
    
    @objc func goGuiderDetailVC(){
        
        delegate?.goGuiderVC(guider: self.guiderModel!)
    }
    func configData(guider:GuideModel){
        self.guiderModel = guider
        self.nameLabel.text = guider.realname
        self.officalLabel.text = guider.certificate
        self.descLabel.text = guider.introduction
        
        let url = URL(string: guider.headimg ?? "")
        self.headerImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_squ"), options: nil, progressBlock: nil, completionHandler: nil)
        if guider.vip == 1 {
            self.vipView.isHidden = false
            self.ViewHeight.constant = 20
        }else {
            self.vipView.isHidden = true
            self.ViewHeight.constant = 0
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
