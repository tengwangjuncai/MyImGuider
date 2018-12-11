//
//  GuiderVC.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/8.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class GuiderVC: BaseViewController,GuiderCardViewDelegate {

    @IBOutlet weak var maskImageView: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    var CityID : Int?
    var bgPic : String?
    var swipeableView : ZLSwipeableView!
    var index = 0
    var loadCardsFromXib = false
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var allGuiders : [GuideModel] = [GuideModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension GuiderVC {
    
    func setup(){
        
        navBarBackgroundAlpha = 0
        navBarShadowImageHidden = true
        view.clipsToBounds = true
        let url = URL(string: bgPic ?? "")
        self.maskImageView.alpha = 0
        self.bgImageView.kf.setImage(with: url, placeholder: UIImage(named: "bgColor"), options: nil, progressBlock: nil, completionHandler: nil)
        self.maskImageView.image = self.bgImageView.image?.blurredImage(withRadius: 30, iterations: 5, tintColor: UIColor.black)
      
        
        swipeableView = ZLSwipeableView()
//        swipeableView.backgroundColor = kThemeRedColor
        let width = kScreenWidth - 100
        let Height = width / 9 * 13
        swipeableView.frame = CGRect(x: 50, y: (kScreenHeight - Height)/2 , width: width, height: Height)
        self.view.addSubview(swipeableView)
        
        swipeableView.numberOfActiveView = 6
        swipeableView.animateView = {(view: UIView, index: Int, views: [UIView], swipeableView: ZLSwipeableView) in
            let degree = CGFloat(sin(0.5*Double(index)))
            let offset = CGPoint(x: 0, y: swipeableView.bounds.height*0.3)
            let translation = CGPoint(x: degree*10, y: CGFloat(-index*5))
            let duration = 0.4
            self.rotateAndTranslateView(view, forDegree: degree, translation: translation, duration: duration, offsetFromCenter: offset, swipeableView: swipeableView)
        }
    }
    
    func blurredAnimation(){
        
        
        UIView.animate(withDuration: 1.5, animations: {
            self.maskImageView.alpha = 1
        }) { (complete) in
            if complete {
                self.bgImageView.isHidden = true
            }
        }
    
        
    }
    
    func cardViewInit()-> UIView?{
        
        if index >= self.allGuiders.count {
            index = 0
        }
        
        let contentView = UIView()
        contentView.frame = swipeableView.bounds
//        contentView.backgroundColor = colorForName(colors[index])
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        
        let cardView = Bundle.main.loadNibNamed("GuiderCardView", owner: self, options: nil)?.first! as! GuiderCardView
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.tag = 100 + index
        contentView.addSubview(cardView)
        
        let model = self.allGuiders[index]
        cardView.configData(guider: model)
        cardView.delegate = self
        cardView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
         index += 1
        return contentView
    }
    
    
    func loadData(){
        
        NetProvider.request(.allGuiderByCityID(CityID ?? 11)) { result in
            if case let .success(response) = result{
                
                guard let data = try! response.mapJSON() as? Dictionary<String, Any> else {
                    print("-----\(response)")
                    return
                }
                
                guard let dict = data["result"] as? Dictionary<String,Any>,let content = dict["content"] else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) else {return}
                
                guard let arr = try? JSONDecoder().decode([GuideModel].self, from: resultData) else {return}
                
                self.allGuiders = arr
                self.blurredAnimation()
                self.swipeableView.nextView = {
                    return self.cardViewInit()
                }
                print(data)
            }
            
        }
    }
    
    func goGuiderVC(guider: GuideModel){
       
        let guiderDetailVC = GuiderDetailVC()
            guiderDetailVC.title = guider.realname
        self.navigationController?.pushViewController(guiderDetailVC, animated: true)
    }
    
    func swipeableViewAction(){
        
        swipeableView.didTap = { view, location in
            
            print("点我了")
        }
        
        swipeableView.didCancel = { view in
            
        }
        
        swipeableView.didDisappear = { view in
            
        }
    }
    
    func colorForName(_ name: String) -> UIColor {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
    }
    
    
    func toRadian(_ degree: CGFloat) -> CGFloat {
        return degree * CGFloat(M_PI/180)
    }
    
    func rotateAndTranslateView(_ view: UIView, forDegree degree: CGFloat, translation: CGPoint, duration: TimeInterval, offsetFromCenter offset: CGPoint, swipeableView: ZLSwipeableView) {
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
            view.center = swipeableView.convert(swipeableView.center, from: swipeableView.superview)
            var transform = CGAffineTransform(translationX: offset.x, y: offset.y)
            transform = transform.rotated(by: self.toRadian(degree))
            transform = transform.translatedBy(x: -offset.x, y: -offset.y)
            transform = transform.translatedBy(x: translation.x, y: translation.y)
            view.transform = transform
        }, completion: nil)
    }
}
