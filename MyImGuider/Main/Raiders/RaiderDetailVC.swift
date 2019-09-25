//
//  RaiderDetailVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 4/11/19.
//  Copyright © 2019 王鹏宇. All rights reserved.
//

import UIKit
import WebKit

class RaiderDetailVC: BaseViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate{
  
    
    
    var webView : WKWebView!
    var raider : RaiderModel?
    var params:Dictionary<String,String>?
    
    var scroll1 = false
    var scroll2 = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
    }
    
    func setup(){
        
        
       
        
        let config = WKWebViewConfiguration()
        
        config.suppressesIncrementalRendering = true
    
        config.userContentController.add(self as WKScriptMessageHandler, name: "imguider")
        
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.scrollView.delegate = self
        

        self.view.addSubview(self.webView)
        
        if let subUrl = self.raider?.url {
            
            let url = "http://h5.imguider.com/tourist/services/" + subUrl
                
                self.webView.load(URLRequest(url:URL(string: url)!))
        }
        
        
        if #available(iOS 11.0, *){
            
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
            
        }else{
            
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
    }

}

extension RaiderDetailVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var disctance = scrollView.contentOffset.y
        
        navBarBackgroundAlpha  = disctance / kNavigationHeight
        
        if(disctance >= kNavigationHeight){
            
            if self.scroll1 {
                return
            }
            
            self.scroll1 = true
            self.scroll2 = false
            self.webView.frame = CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight)
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: disctance + kNavigationHeight)
            
            self.title = self.raider?.title
        }else{
            
            if self.scroll2 {
                
                return
            }
            
            self.scroll1 = false
            self.scroll2 = true
            self.webView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: disctance - kNavigationHeight);
            
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let obj = message.body as! Dictionary<String,Any>
        
        var strSel = obj["method"] as? String
        let param = obj["params"]
        
//        print(param)
        if strSel != nil && param != nil {
            
            strSel = strSel! + ":"
        }
        
//        strSel = "jumpline:"
        
        let sel = Selector(strSel!)
        
        
//        let sel = NSSelectorFromString("jumpscenic:")
//        self.perform(sel, with: param)
        
        if self.responds(to: sel) {
            
            self.params = param as? Dictionary<String, String>
            
            self.perform(sel, with: param)
        }
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        //页面开始加载
        
        self.webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'", completionHandler: nil)
          self.webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'", completionHandler: nil)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        //页面加载结束
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载失败
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        
    }
    
    
    
    @objc func jumpline(_ param:Dictionary<String,String>){
        
    let lineID = param["lineid"]
    print("=======" + lineID!)
        
        let cityTour = CityTourVC()
        
          cityTour.cityID = 11
        
        self.navigationController?.pushViewController(cityTour, animated: true)
        
        
    }
    
   @objc func jumpscenic(_ param:Dictionary<String,String>){
    //
        
    let scenicID = param["scenicid"];
        let scenicVC = ScenicRecordsVC()
    
        let scenic =  Scenic()
            scenic.id = scenicID
        
        scenicVC.scenic = scenic
    
        self.navigationController?.pushViewController(scenicVC, animated: true)
    }
    
   @objc func jumpguider(_ param:Dictionary<String,String>){
        
        let guiderVC = GuiderVC()
        
        guiderVC.CityID = 11
        
        self.navigationController?.pushViewController(guiderVC, animated: true)
    }
    
}
