//
//  AccountVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/8/31.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AccountVC {
    
    func setup(){
        
        let color1 = UIColor.init(red: 199/255.0, green: 208/255.0, blue: 215/255.0, alpha: 1)
        
        let color2 = UIColor.init(red: 74/255.0, green: 112/255.0, blue: 139/255.0, alpha: 1)
        
        let gradientColors:[CGColor] = [color1.cgColor,color2.cgColor]
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.layer.addSublayer(gradientLayer)
        
    }
}
