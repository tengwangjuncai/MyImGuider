//
//  Scenic.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/6.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class Scenic: Codable {
    
    var viewname,pictures,id,ename,openinfo,website : String?
    
    var guides,rank,visit ,lat,lng,inroom,hasmap: Double?
    
    var lines : [LineModel]?
}
