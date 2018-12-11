//
//  CityScenicCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/6.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class CityScenicCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    var scenicArray:[Scenic]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
       let  width = UIScreen.main.bounds.size.width * 140 / 375;
       let  height = width * 200 / 145;
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        
        self.collectionView.register(UINib(nibName: "ScenicPaperCollectionCell", bundle: nil), forCellWithReuseIdentifier:"ScenicPaperCollectionCell")
        
        self.collectionView.backgroundColor = kThemeBgColor
        self.backgroundColor = kThemeBgColor
        self.contentView.backgroundColor = kThemeBgColor
    }

    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension CityScenicCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.scenicArray?.count ?? 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ScenicPaperCollectionCell", for:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let scenicCell = cell as? ScenicPaperCollectionCell
        
        guard let model = self.scenicArray?[indexPath.row] else {return}
        scenicCell?.configData(scnice: model)
    }
}
