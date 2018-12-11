//
//  SectionHeaderView.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/7.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    var titleLabel:UILabel?
    var actionView : UIView?
    var iconImageView : UIImageView?
    var desLabel : UILabel?
    var markLabel :UILabel?
    var itemType : TabItemType?
    weak  var delegate : TabItemDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
        self.contentView.backgroundColor = kThemeBgColor
        
        markLabel = UILabel()
        markLabel?.backgroundColor = KThemeColor
        self.contentView.addSubview(markLabel!)
        titleLabel = UILabel()
        self.contentView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(28)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        })
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        titleLabel?.textColor = kTitleColor
        
        markLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(4)
            make.centerY.equalTo((titleLabel?.snp.centerY)!)
            make.height.equalTo(18)
        })
        
        actionView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        self.contentView.addSubview(actionView!)
        self.actionView?.snp.makeConstraints { (make) in
           make.right.equalToSuperview().offset(-16)
           make.centerY.equalTo((titleLabel?.snp.centerY)!)
           make.width.equalTo(100)
//           make.height.equalTo(30)
        }
        
        iconImageView = UIImageView()
        iconImageView?.image = UIImage(named: "rightarrow")
        iconImageView?.contentMode = .scaleAspectFit
        actionView?.addSubview(iconImageView!)
        iconImageView?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo((self.actionView?.snp.centerY)!)
            make.width.equalTo(12)
            make.height.equalTo(12)
        })
        
        desLabel = UILabel()
        desLabel?.text = "查看全部"
        desLabel?.textAlignment = .right
        desLabel?.font = UIFont.systemFont(ofSize: 13)
        desLabel?.textColor = kContentColor
        actionView?.addSubview(desLabel!)
        
        desLabel?.snp.makeConstraints({ (make) in
            make.top.bottom.left.equalToSuperview()
            make.right.equalTo((iconImageView?.snp.left)!).offset(-3)
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goVC))
        
        actionView?.addGestureRecognizer(tap)
        
    }
    
    @objc func goVC(){
        
        if delegate != nil && (itemType != nil) {
            
            delegate?.goTypeVC(itemType:itemType!)
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
