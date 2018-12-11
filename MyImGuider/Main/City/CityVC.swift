//
//  CityVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/4.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit
import SideMenu

class CityVC: ExpandingTableViewController ,TabItemDelegate{
    
    
    var cityID : Int?
    var cityPageModel : CityPageModel?
    fileprivate var scrollOffset:CGFloat = 0
    var customNav : UIView?
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        setup()
        registerCell()
        configNavBar()
        loadData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension CityVC {
    
    func setup(){
        
//        self.title = ""
        self.view.backgroundColor = UIColor.white
        tableView.backgroundView = UIImageView(image: Asset.backgroundImage.image)
       
        
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"reuseIdentifier")
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        statusBarStyle = .lightContent
        navBarTitleColor = UIColor.white
//        96 123 139
        navBarBarTintColor = UIColor(red: 135/255.0, green: 159/255.0, blue: 176/255.0, alpha: 1)
        
        //tableView 自适应高度
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 100
        
//        if #available(iOS 11.0, *){
//            tableView.contentInsetAdjustmentBehavior = .never
//        }else{
//            self.automaticallyAdjustsScrollViewInsets = true
//        }
        
    }
    
    func registerCell(){
        
        self.tableView.register(UINib(nibName: "TabItemCell", bundle: nil), forCellReuseIdentifier: "TabItemCell")
        
         self.tableView.register(UINib(nibName: "CityScenicCell", bundle: nil), forCellReuseIdentifier: "CityScenicCell")
        
        self.tableView.register(UINib(nibName: "CityLineCell", bundle: nil), forCellReuseIdentifier: "CityLineCell")
        
        self.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
    }
    
    func configNavBar(){
        
        var img = UIImage(named:"searchIcon")
        img = img?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goSearch))
        var img3 = UIImage(named:"侧滑栏")
        img3 = img3?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftItem3 = UIBarButtonItem(image: img3, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backLeft))
        
        self.navigationItem.leftBarButtonItems = [leftItem3,leftItem]
        var img2 = UIImage(named:"CloseButton")
        img2 = img2?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightItem = UIBarButtonItem(image: img2, style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.customNav = UIView.init(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationHeight))
        self.customNav?.backgroundColor = UIColor.lightGray
        
    }
    
    @objc func back(){
        
        let viewControllers:[MenuCityVC?] = navigationController?.viewControllers.map{$0 as? MenuCityVC} ?? []
        
        for vc in viewControllers {
            if let rightButton = vc?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
    
    @objc func backLeft(){
       
        self.present(SideMenuManager.defaultManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func goSearch(){
        
    }
    
    
    
    func loadData(){
        
        NetProvider.request(.cityPage(cityID!)) { result in
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
                
                guard let dict = data["result"] as? Dictionary<String,Any> else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {return}
                
                guard let model = try? JSONDecoder().decode(CityPageModel.self, from: resultData) else {return}
                
                self.cityPageModel = model
                
                self.tableView.reloadData()
                print(data)
            }
            
        }
    }
    
    func goTypeVC(itemType: TabItemType) {
        

        switch itemType {
        case .ScenicItem:
            let scenicVC = ScenicVC()
            scenicVC.title = ""
            scenicVC.cityID = self.cityID
        self.navigationController?.pushViewController(scenicVC, animated: true)
        case .MapItem:
            
           let mapVC = MapVC()
            mapVC.title = "地图"
        self.navigationController?.pushViewController(mapVC, animated: true)
            
        case .CityTourItem:
            
          let  cityTourVC = CityTourVC()
            cityTourVC.title = "城市导览"
            self.navigationController?.pushViewController(cityTourVC, animated: true)
            
        case .GuiderItem:
            
            let guiderVC = GuiderVC()
            guiderVC.CityID = self.cityID
            guiderVC.bgPic = self.cityPageModel?.pictures
            guiderVC.title = "导游"
             self.navigationController?.pushViewController(guiderVC, animated: true)
        case .RaidersItem:
            
            let vc = TripArrangeVC() //TripOverViewVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        default : break
        }
       
    }
}


//tableView  代理操作

extension CityVC {
    
   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y < -45,let navigationControlller = navigationController{
        
        for case let vc as MenuCityVC in navigationControlller.viewControllers {
            if case let rightButton as AnimatingBarButton = vc.navigationItem.rightBarButtonItem {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
    scrollOffset = scrollView.contentOffset.y
    
    let yOffset = scrollView.contentOffset.y
    
    if (yOffset > 0) {
        
        var aplha:CGFloat = 0.0
        
        aplha = yOffset / CGFloat(236 - WRNavigationBar.navBarBottom())
        
        navBarBackgroundAlpha = aplha
        
        if aplha > 0.5 {
            self.title = self.cityPageModel?.cname
        }else {
            self.title = ""
        }
    }
    
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 1 {
            
            return 1;
        }
        return self.cityPageModel?.customlines?.count ?? 3
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"TabItemCell", for: indexPath)
            
            return cell
        }else if indexPath.section == 1 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier:"CityScenicCell", for: indexPath)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityLineCell", for: indexPath)
     
     return cell
     }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
           
            if let tabCell = cell as? TabItemCell{
               tabCell.delegate = self
                tabCell.tagArray = self.cityPageModel?.tags?.components(separatedBy: ",") ?? ["map","guide","view","line"]
            }
        }else if indexPath.section == 1 {
            
            guard let scenicCell = cell as? CityScenicCell else {return}
            scenicCell.scenicArray = self.cityPageModel?.views
        }
        
        guard let lineCell = cell as? CityLineCell,let model = self.cityPageModel?.customlines![indexPath.row] else {
            return
        }
        
        lineCell.configData(line: model)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView .dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView
        
        if section == 1 {
            headerView?.titleLabel?.text = "热门景点"
            headerView?.delegate = self
            headerView?.itemType = TabItemType.ScenicItem
             return headerView
        }else if section == 2 {
            headerView?.titleLabel?.text = "热门讲解"
            headerView?.delegate = self
            headerView?.itemType = TabItemType.CityTourItem
             return headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 60
        }
        
        return 0.000001
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100;
        }else if indexPath.section == 1 {
            
            let  width = UIScreen.main.bounds.size.width * 140 / 375;
            let  height = width * 200 / 145 ;
            
          return height
        }
        
        return (UIScreen.main.bounds.size.width - 32)/16 * 9 + 88
    }
   
    
}



