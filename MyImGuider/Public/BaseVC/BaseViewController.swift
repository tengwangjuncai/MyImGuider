//
//  BaseViewController.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/8/30.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        statusBarStyle = .lightContent
        navBarTitleColor = UIColor.white
        //        96 123 139
        navBarTintColor = UIColor.white
        navBarBarTintColor = UIColor(red: 135/255.0, green: 159/255.0, blue: 176/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.topItem?.title = "";
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
