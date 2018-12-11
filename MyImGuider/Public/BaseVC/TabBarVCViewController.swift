//
//  TabBarVCViewController.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/8/31.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class TabBarVCViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        addChildVC(childVC: HomeVCViewController(), title: "首页", normalImg: "首页-灰色", selectedImg: "首页-蓝色")
        addChildVC(childVC: MenuCityVC(), title: "目的地", normalImg: "目的地-灰色", selectedImg: "目的地-蓝色")
        addChildVC(childVC: AccountVC(), title: "我的", normalImg: "我的-灰色", selectedImg: "我的-蓝色")
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


extension TabBarVCViewController {
    
    func addChildVC(childVC: UIViewController,title : NSString,normalImg : NSString, selectedImg : NSString){
        
        self.tabBarItem.title = title as String
        childVC.title = title as String
        
        var norImg = UIImage(named: normalImg as String)
        norImg = norImg?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        var selImg = UIImage(named: selectedImg as String)
        selImg = selImg?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let tabItem = UITabBarItem(title: title as String, image: norImg, selectedImage: selImg)
        let naVC = BaseNavigationVC()
        naVC.tabBarItem = tabBarItem
        
        naVC.tabBarItem = tabItem
        
        naVC.addChildViewController(childVC)
        
        addChildViewController(naVC)
    }
 }
