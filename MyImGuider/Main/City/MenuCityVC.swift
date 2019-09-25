//
//  MenuCityVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/8/31.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu


class MenuCityVC: ExpandingViewController {

    var pageLabel:UILabel!
    fileprivate var cellsIsOpen = [Bool]()
    lazy var cityArray : [CityModel] = [CityModel]()
    fileprivate lazy  var bgImageView : UIImageView = {[weak self] in
        
        let bg = UIImageView(frame: (self?.view.bounds)!)
        bg.image = UIImage(named: "BackgroundImage")
        return bg
    }()
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        
        setup()
        initLeftVC()
        registerCell()
        loadData()
        addGesture(toView: self.collectionView!)
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

extension MenuCityVC {
    
    // 初始化 界面
    func setup(){
        
        view.insertSubview(bgImageView, belowSubview: collectionView!)//设置背景
        
        var img = UIImage(named:"searchIcon")
        img = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftItem1 = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(goSearch))
        var img3 = UIImage(named:"侧滑栏")
        img3 = img3?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftItem3 = UIBarButtonItem(image: img3, style: UIBarButtonItem.Style.plain, target: self, action: #selector(goLeft))
        self.navigationItem.leftBarButtonItems = [leftItem3,leftItem1]
        
        var img2 = UIImage(named:"Circle")
        img2 = img2?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let rightItem = AnimatingBarButton(image: img2, style: UIBarButtonItem.Style.plain, target: self, action: #selector(goSearch))
        rightItem.normalImageName = "Circle"
        rightItem.selectedImageName = "CloseButton"
        
        rightItem.setup()
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        statusBarStyle = .lightContent
        navBarTitleColor = UIColor.white
        
//        if #available(iOS 11.0, *){
//            
//            self.collectionView!.contentInsetAdjustmentBehavior = .never
//        }else{
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
        
       
        
        
        
        //导航条全透明
//     1.设置导航栏标题属性：设置标题颜色
        
//    self.title = ""
//    self.navigationController?.navigationBar.isTranslucent = true
// self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
//    self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func initLeftVC(){
        
        //侧滑栏
        let sideMenuNav = UISideMenuNavigationController(rootViewController: AccountVC())
        
            sideMenuNav.navigationBar.isHidden = true
        SideMenuManager.defaultManager.menuLeftNavigationController = sideMenuNav
        
        SideMenuManager.defaultManager.menuAnimationBackgroundColor = UIColor.init(patternImage: UIImage(named: "bgColor")!)
//        UIColor.init(patternImage: UIImage(named: "bgColor")!)
//        UIColor.init(red: 199/255.0, green: 208/255.0, blue: 215/255.0, alpha: 1)
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)

        //侧滑推出手势
        //    SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.65
       
    }
    
    //注册 cell
    func registerCell(){
        
        let nib = UINib(nibName:"CityCollectionCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "CityCollectionCell")
    }
    
    fileprivate func fillCellIsOpenArray(){
        cellsIsOpen = Array(repeating: false, count:self.cityArray.count)
    }
    //获取数据
    func loadData(){
       
        NetProvider.request(.recommendCity) { result in
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
              
                
                if let rt = data["result"] as? Dictionary<String, Any>, let array = rt["cities"] as? [Any] {

                    for dict in array {
                     
                        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {return}
                        
                        guard let model = try? JSONDecoder().decode(CityModel.self, from: data) else {return}
                        self.cityArray.append(model)
                    }
                    
                    self.fillCellIsOpenArray()
                    self.collectionView?.reloadData()
                }
                
            }
        }
        
       
    }
    
    func addGesture(toView:UIView){
        
        let upGestrue = Init(UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let dowGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))) {
            $0.direction = .down
        }
        
        view.addGestureRecognizer(upGestrue)
        view.addGestureRecognizer(dowGesture)
    }

    @objc func swipeHandler(_ sender:UISwipeGestureRecognizer){
        
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? CityCollectionCell else {
            return
        }
        
        if cell.isOpened == true && sender.direction == .up {
            let cityVC = CityVC()
            let model:CityModel = self.cityArray[currentIndex]
            cityVC.cityID = model.id
            pushToViewController(cityVC)
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

extension MenuCityVC {
    
    @objc func goSearch(){
        
        
    }
    
    @objc func goLeft(){
        
 self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension MenuCityVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        
        return self.cityArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt  indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return collectionView.dequeueReusableCell(withReuseIdentifier:"CityCollectionCell", for:indexPath );
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
         super .collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        
        guard let cell = cell as? CityCollectionCell else {return}
        
        let city = self.cityArray[indexPath.row]

        cell.city = city
        cell.cellIsOpen(self.cellsIsOpen[indexPath.row],animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CityCollectionCell,currentIndex == indexPath.row else {return}
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        }else {
            
            let cityVC = CityVC()
            let model:CityModel = self.cityArray[indexPath.row]
            cityVC.cityID = model.id
            pushToViewController(cityVC)
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                
                
                
                rightButton.animationSelected(true)
            }
        }
        
    }
    
    
    
    
}
