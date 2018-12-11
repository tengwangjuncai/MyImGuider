//
//  ScenicCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/10.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

protocol ScenicCellDelegate : class {
    
    func pushVC(scenic:Scenic)
}

class ScenicCell: UICollectionViewCell {

    @IBOutlet weak var scenicImageView: UIImageView!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var enNameLabel: UILabel!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    weak var delegate : ScenicCellDelegate?
    var scenic : Scenic?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        // Initialization code
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let delta = 1 - (Constant.featuredHeight - frame.height)/(Constant.featuredHeight - Constant.standardHeight)
        
        let alpha = Constant.maxAlpha - (delta * (Constant.maxAlpha - Constant.minAlpha))
        overlayView.alpha = alpha
        
        let scale = max(delta, 0.6)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        enNameLabel.alpha = delta
    }
    
    func configData(_ scenic:Scenic){
        
        self.scenic = scenic
        self.titleLabel.text = scenic.viewname
        self.enNameLabel.text = scenic.ename
        let iconUrl = URL(string: scenic.pictures?.components(separatedBy:",").first ?? "")
        self.scenicImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "placeholder_rec"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    
    func disappearAnimation(){
        
        centerY.constant = CGFloat(WRNavigationBar.navBarBottom() - 22) - (kScreenWidth/16 * 9/2)
        
        titleLabel.transform = CGAffineTransform(scaleX: 17/25.0, y: 17/25.0)
        UIView.animate(withDuration: 0.4, animations: {
            self.enNameLabel.alpha = 0
            self.overlayView.alpha = 0
            self.layoutIfNeeded()
        }){ (complete) in
            self.delegate?.pushVC(scenic:self.scenic!)
        }
        
    }
    
    func appearAnimation(){
        
        centerY.constant = 0
        titleLabel.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.5, animations: {
            self.enNameLabel.alpha = 1
            self.overlayView.alpha = 0.2
            self.layoutIfNeeded()
        })
    }

}

private extension ScenicCell {
    
    struct Constant {
        
        static let featuredHeight: CGFloat = kScreenWidth/16 * 9
        static let standardHeight: CGFloat = 100
        
        static let minAlpha:CGFloat = 0.1
        static let maxAlpha:CGFloat = 0.6
    }
}

