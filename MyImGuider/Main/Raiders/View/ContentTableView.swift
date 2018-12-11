//
//  ContentTableView.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 10/19/18.
//  Copyright © 2018 王鹏宇. All rights reserved.
//

import UIKit

class ContentTableView: UITableView,UIGestureRecognizerDelegate{

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    

}
