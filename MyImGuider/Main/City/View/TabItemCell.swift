//
//  TabItemCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/4.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

protocol TabItemDelegate : class {
    
    func goTypeVC(itemType:TabItemType)
}

class TabItemCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate : TabItemDelegate?
    
    lazy var items:[itemType] = [itemType]()
    var tagArray:Array<String>?{
        didSet{
            
            self.items.removeAll()
            for  tag in tagArray! {
                
                if let dic = allItems[tag] {
                    self.items.append(dic)
                }
            }
            self.collectionView.reloadData()
        }
    }
    typealias itemInfo = (title: String,imageName:String,selectedNum:String)
    
    typealias itemType = (title: String,imageName:String,selectedNum:TabItemType)
    fileprivate var allItems:[String:itemType] = ["view":("景点","sightseeing",TabItemType.ScenicItem),"line":("主题线路","urbanline",TabItemType.CityTourItem),"guide":("导游","tourguide",TabItemType.GuiderItem),"map":("地图","mapIcon",TabItemType.MapItem),"strategy":("推荐行程","推荐行程",TabItemType.RaidersItem)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.collectionView.register(UINib.init(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40)/4, height: 80)
        layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
//
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TabItemCell {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let itemCell = cell as? ItemCell
    
        itemCell?.iconImageView.image = UIImage(named: self.items[indexPath.row].imageName)
        itemCell?.tagNameLabel.text =  self.items[indexPath.row].title
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            delegate?.goTypeVC(itemType: self.items[indexPath.row].selectedNum)
    }
    
}
