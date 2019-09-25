//
//  Utils.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/7.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

public enum TabItemType {
    
    case ScenicItem  // 景点
    case CityTourItem //城市导览
    case GuiderItem //导游
    case ActionItem//活动
    case RaidersItem//攻略
    case TicketsItem//门票
    case MapItem // 地图
    case BusinessItem // 商家
}

let  kScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let  kScreenHeight:CGFloat = UIScreen.main.bounds.size.height
let  kNavigationHeight:CGFloat = 84
let  kHeaderImageHeight:CGFloat = kScreenWidth/16 * 9

let  KThemeColor = UIColor.hexStringToColor(hexString: "#00B8E4")
let  kThemeDarkColor = UIColor.hexStringToColor(hexString:"#2A2827")
let  kThemeRedColor = UIColor.hexStringToColor(hexString:"#E64461")
let  kThemeBgColor = UIColor.hexStringToColor(hexString:"#F7F7F7")

let  kTitleColor = UIColor.hexStringToColor(hexString:"#242A34")
let  kSubitleColor = UIColor.hexStringToColor(hexString:"#5A5A5A")
let  kContentColor = UIColor.hexStringToColor(hexString:"#969696")

let  kMaskColor =  kTitleColor.withAlphaComponent(0.2)

let  kPlaceholdRec = UIImage(named: "placeholder_rec")
let  kPlaceholdSqu = UIImage(named: "placeholder_squ")
let  kPlaceholdIcon = UIImage(named: "default")
class Utils: NSObject {

}


extension UIColor {
    
    public class func hexStringToColor(hexString: String) -> UIColor{
        
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }

}


extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
}
