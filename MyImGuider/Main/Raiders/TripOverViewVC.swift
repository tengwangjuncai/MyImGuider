//
//  TripOverViewVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/20.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class TripOverViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configNavBar()
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TripOverViewVC {
    
    func setup(){
        
        self.title = "我的定制"
        self.tableView.register(UINib(nibName: "TripHeaderCell", bundle: nil), forCellReuseIdentifier: "TripHeaderCell")
         self.tableView.register(UINib(nibName: "DayArrangeCell", bundle: nil), forCellReuseIdentifier: "DayArrangeCell")
        self.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
        //tableView 自适应高度
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 100
    }
    
    func configNavBar(){
        
        var img = UIImage(named:"设置-4") 
        img = img?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goSetVC))
        self.navigationItem.leftBarButtonItem = leftItem
        var img2 = UIImage(named:"历史-3")
        img2 = img2?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightItem = UIBarButtonItem(image: img2, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goAllTrip))
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func goSetVC(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goAllTrip(){
        
    }
}

extension TripOverViewVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
             return tableView.dequeueReusableCell(withIdentifier: "TripHeaderCell") ?? UITableViewCell()
            
        }else {
            
             return tableView.dequeueReusableCell(withIdentifier: "DayArrangeCell") ?? UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let dayCell = cell as? DayArrangeCell else {return}
        
        if indexPath.row == 0 && indexPath.section != 0 {
            
            dayCell.isHideCityView = false
        }else {
            dayCell.isHideCityView = true
    }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as! SectionHeaderView
        
        if(section == 0){
            
            
           
            headerView.titleLabel?.text = "罗马假日-三日游"
            headerView.iconImageView?.image = UIImage(named: "加号")
            headerView.desLabel?.text = ""
            headerView.markLabel?.backgroundColor = UIColor.clear
            return headerView
            
        }else if (section == 1){
             headerView.titleLabel?.text = "行程概览"
            headerView.iconImageView?.image = UIImage(named: "")
            headerView.desLabel?.text = "￥40800/人"
            headerView.desLabel?.textColor = kTitleColor
             headerView.markLabel?.backgroundColor = UIColor.clear
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1 {
            
            return 65
        }
        return 0.00001
    }
}
