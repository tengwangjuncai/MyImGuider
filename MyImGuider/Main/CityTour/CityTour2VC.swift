//
//  CityTour2VC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 4/9/19.
//  Copyright © 2019 王鹏宇. All rights reserved.
//

import UIKit

class CityTour2VC: BaseViewController {

    var layout: CarouselViewLayout!
    var collectionView: UICollectionView!
    var lineArray : [LineModel]?
    var cityID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        loadData()
    }
    
    private func setupUI(){
        
        layout = CarouselViewLayout(anim: .carousel3)
        layout.scrollDirection = .vertical
        layout.visbleCount = 8
        
        let width = UIScreen.main.bounds.width - 40
        let height = CGFloat( width * 9 / 16) + 20
        
        layout.itemSize = CGSize(width: width, height: height)
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: "CityTourCCell", bundle: nil), forCellWithReuseIdentifier: "CityTourCCell")
        
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
    }
    
    
    func loadData(){
        NetProvider.request(.allCityTour(cityID ?? 11)) { result in
              if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
                
                guard let dict = data["result"] as? Dictionary<String,Any>,let content = dict["content"] else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) else {return}
                
                guard let arr = try? JSONDecoder().decode([LineModel].self, from: resultData) else {return}
                
                self.lineArray = arr
                self.collectionView.reloadData()
                print(data)
            }
            
        }
    }


}


extension CityTour2VC: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  self.lineArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityTourCCell", for: indexPath) as! CityTourCCell
        
        if  let line = self.lineArray?[indexPath.row]{
            
            cell.configData(line: line)
        }
        
        return cell
    }
    
    
    
}
