//
//  RaidersVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/18.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class RaidersVC: BaseViewController {
    
    var layout: CarouselViewLayout!
    
    var collectionView: UICollectionView!
    
    var pageControl: UIPageControl!
    
    let cellWidth = kScreenWidth * 56 / 75
    
    var dataSource: [RaiderModel] = []
    
    var cityID:Int = 11

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = kThemeBgColor
        
        setup()
        loadData()
        
    }
    
    func setup(){
        
        let layout = CarouselViewLayout(anim: .carousel1)
        
        let cellHeight = cellWidth * 733 / 560
        
        layout.scrollDirection = .horizontal
        layout.visbleCount = 8
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: (kScreenHeight - cellHeight) / 2, width: kScreenWidth, height: cellHeight), collectionViewLayout: layout)
        
        collectionView.backgroundColor = kThemeBgColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "RaiderCell", bundle: nil), forCellWithReuseIdentifier: "RaiderCell")
        
        self.view.addSubview(collectionView)
//        collectionView.center = self.view.center
    }
    
    
    func createData(){
        let content = [["title": "休闲小资的三日巴黎生活","labels": "国语,人文","url": "strategy/17","guideheadimg": "http://cncdn.imguider.com/upload/images/20170718/ee88e19e-f54d-48be-8393-9d9d9a69ff9f.png","pictures": "http://cncdn.imguider.com/upload/images/20171012/1507803574587.jpg"],["title": "一场人文与艺术的旅行","labels": "国语,历史","url": "strategy/16","guideheadimg": "http://cncdn.imguider.com/upload/images/20170718/ee88e19e-f54d-48be-8393-9d9d9a69ff9f.png","pictures": "http://cncdn.imguider.com/upload/images/20171012/1507803687549.jpg"],["title": "一顿巴黎的饕餮盛宴","labels": "国语,人文","url": "strategy/12","guideheadimg": "http://cncdn.imguider.com/upload/images/20170718/ee88e19e-f54d-48be-8393-9d9d9a69ff9f.png","pictures": "http://cncdn.imguider.com/upload/images/20171012/1507805643636.jpg"],["title": "不可能完成的任务","labels": "国语,人文","url": "strategy/7","guideheadimg": "http://cncdn.imguider.com/upload/images/20170718/ee88e19e-f54d-48be-8393-9d9d9a69ff9f.png","pictures": "http://cncdn.imguider.com/upload/images/20170921/1505982784301.jpg"],["title": "休闲小资的三日巴黎生活","labels": "国语,人文","url": "strategy/17","guideheadimg": "http://cncdn.imguider.com/upload/images/20170718/ee88e19e-f54d-48be-8393-9d9d9a69ff9f.png","pictures": "http://cncdn.imguider.com/upload/images/20171012/1507794532822.jpg"],]
        
        
        for item in content {
            
            let raider = RaiderModel()
            raider.title = item["title"]
            raider.url = item["url"]
            raider.guideheadimg = item["guideheadimg"]
            raider.pictures = item["pictures"]
            raider.labels = item["labels"]
            
            self.dataSource.append(raider)
        }
        
        self.collectionView.reloadData()
        
    }
    
    func loadData(){
        
        NetProvider.request(.cityRaidersByCityID(self.cityID)) { result in
            
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String,Any> else{
                    
                    return
                }
                
//               guard let dict = data["result"] as? Dictionary<String,Any> else {return}
//
//                guard let content = dict["content"] else {return}
//
//                guard let resultData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)else {return}
//
//                guard (try? JSONDecoder().decode([RaiderModel].self, from: resultData)) != nil else {return}
                
                self.createData()
                print(data)
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension RaidersVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var index = Int(ceil(Float(scrollView.contentOffset.x / CGFloat(cellWidth))))
        
        if index < 0 {
            index = 0
        }
        
//        self.pageControl.currentPage = index
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RaiderCell", for: indexPath)  as! RaiderCell
        
        let raider = self.dataSource[indexPath.row]
        
        cell.configData(raider: raider)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let raider = self.dataSource[indexPath.row]
        
        let detailVC = RaiderDetailVC()
        detailVC.raider = raider
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
