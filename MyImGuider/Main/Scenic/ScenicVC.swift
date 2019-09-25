//
//  ScenicVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/8.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit


class ScenicVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,ScenicCellDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var cityID : Int?
    var allViews :[Scenic] = [Scenic]()
    open var currentCell : ScenicCell?
    var currentIndex : Int = 0
    lazy var maskImageView : UIImageView = UIImageView()
    lazy var maskView : UIView = UIView()
   fileprivate lazy  var subVC : ScenicRecordsVC = ScenicRecordsVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentCell != nil {
            self.comeBackAnimation(cell: self.currentCell!)
        }
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

extension ScenicVC {
    
    func setup(){
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        self.collectionView.register(UINib(nibName:"ScenicCell", bundle: nil), forCellWithReuseIdentifier:"ScenicCell")
        

        if #available(iOS 11.0, *){
            collectionView.contentInsetAdjustmentBehavior = .never
        }else{
           self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.collectionView.backgroundColor = UIColor.clear
//        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named:"BackgroundImage")!)
        
        self.view .addSubview(self.maskImageView)
        let  Y:CGFloat = kScreenWidth/16 * 9
        self.maskImageView.frame = CGRect(x: 0, y: Y, width: kScreenWidth, height: kScreenHeight - Y)
        self.maskImageView.alpha = 0
        self.maskImageView .addSubview(maskView)
        maskView.frame = self.maskImageView.bounds
        maskView.backgroundColor = kTitleColor
        maskView.alpha = 0.5
       
    }
    
    func loadData(){
        NetProvider.request(.allViews(cityID ?? 11)) { result in
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
                
                guard let dict = data["result"] as? Dictionary<String,Any>,let content = dict["content"] else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) else {return}
                
                guard let arr = try? JSONDecoder().decode([Scenic].self, from: resultData) else {return}
                
                self.allViews = arr
                self.collectionView.reloadData()
                
            }
            
        }
    }
    
}

extension ScenicVC {
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let drgOffset = kScreenWidth/16 * 9 - 100
        
       currentIndex =  max(0, Int((scrollView.contentOffset.y + CGFloat(WRNavigationBar.navBarBottom()) ) / drgOffset))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ScenicCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let scenicCell = cell as? ScenicCell else {
            return
        }
        if self.allViews.count != 0 {
            let scenic = self.allViews[indexPath.row]
            scenicCell.configData(scenic)
            scenicCell.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let focusViewLayout = collectionView.collectionViewLayout as? FocusViewLayout else {
            fatalError("error casting focus layout from collection view")
        }
        
        let offset = focusViewLayout.dragOffset * CGFloat(indexPath.item)
        if currentIndex != indexPath.row {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            
        }else {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? ScenicCell else {return}
            self.exitAnimation(cell: cell)
           
        }
    }
    
    
    func pushVC(scenic: Scenic) {
        let recordsVC = ScenicRecordsVC()
        recordsVC.scenic = scenic
        recordsVC.isAnimation = true
        recordsVC.superVC = self
        self.navigationController?.pushViewController(recordsVC, animated: false)
    }
    
    func exitAnimation(cell:ScenicCell){
       
        self.maskImageView.image = self.subVC.view.takeSnapshot(CGRect(x: 0, y: kHeaderImageHeight, width: kScreenWidth, height: kScreenHeight - kHeaderImageHeight))
        self.maskImageView.isHidden = false
        self.maskImageView.contentMode = .scaleAspectFill
        self.maskImageView.backgroundColor = UIColor.white
        
        cell.disappearAnimation()
        UIView.animate(withDuration: 0.4) {
            self.maskImageView.alpha = 1
            self.maskView.alpha = 0
        }
        self.currentCell = cell;
    }
    func comeBackAnimation(cell:ScenicCell){
        
//     
        cell.appearAnimation()
        self.maskImageView.alpha = 0.5
        self.maskImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.maskImageView.isHidden = true
        
//        UIView.animate(withDuration: 0.5, animations: {
//             self.maskImageView.alpha = 0.1
//        }) { (isFinish) in
//
//            self.maskImageView.isHidden = true
//        }
        self.currentCell = nil;
    }
}

