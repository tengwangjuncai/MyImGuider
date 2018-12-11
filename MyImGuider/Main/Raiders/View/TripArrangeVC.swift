//
//  TripArrangeVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 10/18/18.
//  Copyright © 2018 王鹏宇. All rights reserved.
//

import UIKit

class TripArrangeVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
   
    

    
    @IBOutlet weak var tableView: UITableView!
    var headerView : UIView!
    
    var shouldScroll : Bool = true
//    var bottomShouldScroll : Bool = true
//    var upperShouldScroll : Bool = true
    
    var containnerCell : ContainerCell?
    
    var dateCollection : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    
    

}

extension TripArrangeVC {
    
    func setup(){
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 4 * 3))
        headerView.backgroundColor = UIColor.red
        self.tableView.tableHeaderView = headerView
        
//        self.tableView.register(UINib(nibName: "ContainerCell", bundle: nil), forCellReuseIdentifier: "ContainerCell")
//
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        let layout = UICollectionViewFlowLayout()
        
        let Y = kScreenWidth / 4 * 3
        dateCollection = UICollectionView(frame: CGRect(x: 0, y: Y, width: 60, height: 500), collectionViewLayout: layout)
        dateCollection.backgroundColor = UIColor.green
        tableView.addSubview(dateCollection)
        
    }
    
    

}

extension TripArrangeVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
    }
    //当滑动 pageView 时  当前的tablView要禁止滑动
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
            
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return self.tableView.bounds.height
//    }
    

    
}
