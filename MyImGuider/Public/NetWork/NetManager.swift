//
//  NetManager.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/3.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import Foundation
import Moya



let NetProvider  = MoyaProvider<NetType>()


public enum NetType {
   
    
    case recommendCity //获取推荐城市
    case allCity   //获取所有上架城市
    case cityPage(Int) //获取城市详情
    case allCityTour(Int) //获取城市下所有线路讲解
    case allViews(Int) //获取城市下所有景点
    case scenicDetail(String) //获取景点下的所有讲解
    case allGuiderByCityID(Int) //获取城市下的所有导游
    
}

//请求配置

extension NetType: TargetType {
    
    //服务器地址
    public var baseURL: URL {
        
        switch self {
    
        case .allCity,.cityPage(_),.recommendCity,.allCityTour(_),.allViews(_),.scenicDetail(_),.allGuiderByCityID(_):
            return  URL(string: "https://www.imguider.com/tourist/services/")!
        }
       
        }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .recommendCity:
            return "v2/homepage/cities"
        case .allCity:
            return "allcities"
        case .cityPage(let id):
            return "v2/city/\(id)"
        case .allCityTour(let cityID):
            return "city/\(cityID)/lines"
        case .allViews(let cityID):
            return "city/\(cityID)/views/v13"
        case .scenicDetail(let scenicID):
            return "viewandguides/\(scenicID)/v2"
        case .allGuiderByCityID(let cityID):
            return "city/\(cityID)/guiders"
        }
        
    }
    
    //请求类型
    public var method: Moya.Method {
        switch self {
        case .recommendCity,.allCity,.cityPage(_),.scenicDetail(_):
        return .get
        case .allCityTour(_),.allViews(_),.allGuiderByCityID(_):
        return .post
       
        }
    }
    
    
    //做测试的单元测试
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //请求任务事件
    public var task: Task {
        
        switch self {
//        case .cityPage(_):
//        
//            return .requestParameters(parameters: params,encoding:URLEncoding.default)
        case .allCityTour(_),.allViews(_),.allGuiderByCityID(_):
            var params = Dictionary<String, Any>()
            params["pageno"] = 0
            params["pagesize"] = 0
            
            return .requestParameters(parameters: params, encoding:JSONEncoding.default)
        default:
            return  .requestPlain
        }
    }
    
    //请求头
    public var headers: [String : String]? {
        
        
        return nil
    }
    
}


