//
//  CityPageModel.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/6.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class CityPageModel: Codable {

    var cname,country,fname,lat,lng,name,pictures,tags :String?
    var id :Int?
    var customlines:[LineModel]?
    var views:[Scenic]?
}
