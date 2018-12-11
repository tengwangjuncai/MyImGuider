//
//  CityTourVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/8.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class CityTourVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var lineArray : [LineModel]?
    var cityID : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CityTourVC {
    
    func setup(){
        
        tableView.register(UINib(nibName: "CityLineCell", bundle: nil), forCellReuseIdentifier:"CityLineCell")
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
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
                self.tableView.reloadData()
                print(data)
            }
            
        }
    }
}

extension CityTourVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.lineArray?.count ?? 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "CityLineCell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let lineCell = cell as? CityLineCell else {
            return
        }
        if self.lineArray?.count != nil {
            let model = self.lineArray![indexPath.row]
            lineCell.configData(line: model)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return (UIScreen.main.bounds.size.width - 32)/16 * 9 + 88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView")
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 16
    }
    
    
}
