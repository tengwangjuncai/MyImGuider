//
//  BaseNavigationVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/8/31.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class BaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
    
       
        super.viewDidLoad()
       
//        navBarBarTintColor = UIColor.brown
//        navBarShadowImageHidden = true
//        navBarBarTintColor = UIColor.black
//        [[UIBarButtonItem, appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault]
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super .pushViewController(viewController, animated: animated)
        if self.viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true//跳转后 隐藏tabbar
        }
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
