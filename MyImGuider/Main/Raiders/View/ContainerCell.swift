//
//  ContainerCell.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 10/18/18.
//  Copyright © 2018 王鹏宇. All rights reserved.
//

import UIKit

class ContainerCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
   
    

    @IBOutlet weak var tableView: UITableView!
    
    var shouldScroll : Bool = false{
        didSet {
            
            if !shouldScroll{
                self.tableView.contentOffset = CGPoint.zero
            }
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.green
        self.tableView.panGestureRecognizer.delaysTouchesBegan = false;
//        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollEnable(notif:)), name: NSNotification.Name(rawValue: "goTop"), object: nil)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ContainerCell {
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if let scrollView = object as? UIScrollView {
//
//            if scrollView.panGestureRecognizer.state == UIGestureRecognizerState.changed {
//                 NotificationCenter.default.post(name: NSNotification.Name.init("PageViewGestureState"), object:"change")
//
//            }else if (scrollView.panGestureRecognizer.state == UIGestureRecognizerState.ended){
//
//                  NotificationCenter.default.post(name: NSNotification.Name.init("PageViewGestureState"), object:"end")
//            }
//        }
//    }
    
   
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        
        if !self.shouldScroll {
            
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        if scrollView.contentOffset.y < 0 {
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
             self.shouldScroll = false
            scrollView.contentOffset = CGPoint.zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        
        return  cell
    }
    
    
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if otherGestureRecognizer.view?.isKind(of: UITableView.self) ?? false {
//
//            return true
//        }
//        return false
//    }
}
