//
//  UIView+Shadow.swift
//  ImGuider X
//
//  Created by 王鹏宇 on 9/29/18.
//  Copyright © 2018 imguider. All rights reserved.
//

import UIKit

enum ShadowType {
    case btn
    case card
    case dayArrange
    case account
}

extension  UIView {
    
    func addShadow(type : ShadowType ){
        
        switch type {
        case .btn:
            addBtnShadow()
        case .card:
            addCardCellShadow()
        case .dayArrange:
            addDayArrangeCellShadow()
        case .account:
            addAccountCellShadow()
        }
    }
    
    private func addBtnShadow(){
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 20
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width:0, height:20)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
    }
    
    private func addCardCellShadow(){
        
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width:0, height:10)

//        let shadowPath = UIBezierPath(rect: CGRect(x: 3, y: 3, width:self.frame.width - 6 , height:self.frame.height - 3))
        
//        self.layer.shadowPath = shadowPath.cgPath
    }
    
    private func addDayArrangeCellShadow(){
        
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 3, y: 3, width:self.frame.width - 6 , height:self.frame.height - 3))

        self.layer.shadowPath = shadowPath.cgPath
        
    }
    
    private func addAccountCellShadow(){
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width:0, height:7)
    }
}



extension UIView {
    
    func screenShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
