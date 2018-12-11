//
//  TripHeaderCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/20.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class TripHeaderCell: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource{
   
    

    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dataSource :[Any] = [Any]()
    
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate let items: [ItemInfo] = [("item0", "Boston"), ("item1", "New York"), ("item2", "San Francisco"), ("item3", "Washington")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.selectionStyle = .none
        self.collectionView.register(UINib(nibName: "ScenicPaperCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ScenicPaperCollectionCell")
        
         let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let  width = 160;
        let  height = 200;
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension TripHeaderCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ScenicPaperCollectionCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let indexCell = cell as? ScenicPaperCollectionCell else {
            return
        }
        
        indexCell.iconImageView.image = UIImage(named: self.items[indexPath.row].imageName)
    }
    
    
}
