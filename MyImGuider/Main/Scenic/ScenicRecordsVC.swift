//
//  ScenicRecordsVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/10.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class ScenicRecordsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var headerImageView:UIImageView = UIImageView()
    var scenic : Scenic?
    weak var superVC : ScenicVC?
    var isTop : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configNav()
        loadData()
        // Do any additional setup after loading the view.
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.superVC?.maskImageView.image = self.view.takeSnapshot(CGRect(x: 0, y: kHeaderImageHeight, width: kScreenWidth, height: kScreenHeight - kHeaderImageHeight))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ScenicRecordsVC {
    
    func setup(){
        
        self.title = scenic?.viewname
        self.headerImageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth/16 * 9)
        self.headerImageView.contentMode = .scaleAspectFill
        self.headerImageView.clipsToBounds = true
        let iconUrl = URL(string: scenic?.pictures?.components(separatedBy:",").first ?? "")
        self.headerImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "placeholder_rec"), options: nil, progressBlock: nil, completionHandler: nil)
        let headerView = UIView(frame:self.headerImageView.frame)
        headerView.addSubview(self.headerImageView)
        self.tableView.tableHeaderView = headerView
        //tableView 自适应高度
//                self.tableView.rowHeight = UITableViewAutomaticDimension
//                self.tableView.estimatedRowHeight = 124
        self.tableView.register(UINib(nibName: "ScenicRecordCell", bundle: nil), forCellReuseIdentifier: "ScenicRecordCell")
        
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        self.view.backgroundColor = kThemeBgColor
//            UIColor.init(patternImage: UIImage(named:"BackgroundImage")!)
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func configNav(){
        
        let button:UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(named: "返回"), for: .normal)
        //        /*向左进行偏移*/
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -44, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backItem = UIBarButtonItem.init(customView: button)
        
        self.navigationItem.leftBarButtonItem = backItem

    }
    
    func loadData(){
        
        NetProvider.request(.scenicDetail(self.scenic?.id ?? "")) { result in
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
                
                guard let dict = data["result"] as? Dictionary<String,Any> else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {return}
                
                guard let scenic = try? JSONDecoder().decode(Scenic.self, from: resultData) else {return}
                
                self.scenic = scenic
                
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    @objc func back(){
        
        if isTop {
            self.navigationController?.popViewController(animated: false)
        }else {
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                self.navigationController?.popViewController(animated: false)
            }
        }
        
    }
}


extension ScenicRecordsVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y;
        let H = kScreenWidth/16 * 9.0;
        if (yOffset <= 0) {
            let factor = -yOffset + H ;
            let f = CGRect(x: -(kScreenWidth * factor/H - kScreenWidth)/2, y: yOffset, width: kScreenWidth * factor/H, height: factor)
            self.headerImageView.frame = f;
            self.isTop = true
        }else{
            
            self.isTop = false
            var aplha:CGFloat = 0.0
            
            aplha = yOffset / CGFloat(Int(H) - WRNavigationBar.navBarBottom())
            
            navBarBackgroundAlpha = aplha
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.scenic?.lines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "ScenicRecordCell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let recordCell = cell as? ScenicRecordCell else {
            return
        }
        
        if indexPath.row <= (self.scenic?.lines?.count)! {
            let model = self.scenic?.lines![indexPath.row]
            
            recordCell.configData(lineModel: model!)
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let str = self.scenic?.lines?[indexPath.row].linedesc ?? ""
        
        if str.count > 0 {
            return 150
        }else {
            return 111
        }
        
    }
}
