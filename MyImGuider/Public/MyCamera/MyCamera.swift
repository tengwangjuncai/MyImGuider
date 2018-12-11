//
//  MyCamera.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 10/15/18.
//  Copyright © 2018 王鹏宇. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MyCamera: UIViewController,AVCapturePhotoCaptureDelegate {
    
    
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    var imageView : UIImageView!
    var focusView : UIView!
    var image : UIImage = UIImage()
    
    // 捕获设备 通常是前置摄像头 后置摄像头， 麦克风（音频输入）
    var device : AVCaptureDevice!
    
    // AVCaptureDeviceInput 输入设备 它使用 AVCaptureDevice 来初始化
    var inputDevice : AVCaptureDeviceInput?
    // 当启动摄像头开始捕获输入
    var output : AVCaptureMetadataOutput!
    var imageOutPut : AVCaptureStillImageOutput!
    // 由它把输入输出结合在一起， 并开始启动捕获设备（摄像头）
    var session : AVCaptureSession!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var isFlashOn : Bool = false
    var canCa : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IsOk()
        setup()
        initCamera()
    }

    
    @IBAction func back(_ sender: UIButton) {
        
        self.imageView.removeFromSuperview()
        
        self.session.stopRunning()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeCamera(_ sender: UIButton) {
        
        //获取之前的摄像头
        guard var position = self.inputDevice?.device.position else {return}
        //获取当前应该显示的镜头
        position = position == .front ? .back : .front
        
        //创建新的device
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        //获取前置摄像头
        let videoInput = try? AVCaptureDeviceInput(device: device!)
        
        //切换
        session.removeInput(self.inputDevice!)
        
        session.addInput(videoInput!)
        session.commitConfiguration()
        
        self.inputDevice = videoInput
    }
    
    @IBAction func flashAction(_ sender: UIButton) {
        
        try? device.lockForConfiguration()
        switch device.flashMode.rawValue {
        case 0:
            device!.flashMode = AVCaptureDevice.FlashMode.on
            self.flashBtn.setImage(UIImage(named: "闪光灯-开")
                , for: UIControlState.normal)
            break
        case 1:
            device.flashMode = AVCaptureDevice.FlashMode.auto
            self.flashBtn.setImage(UIImage(named: "闪光灯-关")
                , for: UIControlState.normal)
            break
        default:
            
            device!.flashMode = AVCaptureDevice.FlashMode.off
            self.flashBtn.setImage(UIImage(named: "闪光灯-关")
                , for: UIControlState.normal)
        }
        
        device.unlockForConfiguration()
    }
    
    
    @IBAction func takePhotosAction(_ sender: UIButton) {
        
    
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.authorized {
            
        }
        
    }
    
    
    func shutterCamera(){
       
        let videoConnection : AVCaptureConnection? = imageOutPut.connection(with: AVMediaType.video)
        
        if videoConnection == nil {
            print("take photo failed")
            
            return
        }
      
        self.imageOutPut.captureStillImageAsynchronously(from: videoConnection ?? AVCaptureConnection()) { (_ imageDataSampleBuffer : CMSampleBuffer?, _ error : Error?) in
            
            if imageDataSampleBuffer == nil {
                return
            }
            
            guard let imageData : Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) else {return} //照片数据流
            
            if let sampleImage = UIImage(data: imageData){
                self.image = sampleImage
                
                
            }
            
            
            
        }
        
    }
    
    
    
    func saveImageToPhotoAlbum(image : UIImage){
    
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageDidFinishSaving(image:error:)), nil)
    }
    
    @objc func imageDidFinishSaving(image: UIImage?,error : Error){
        
        if let thumb = image {
             self.thumbImageView.image = thumb
        }
    }
   
}



extension MyCamera {
    
    func IsOk() {
        
        //相机权限
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        //此应用程序没有被授权访问的照片数据。可能是家长控制权限
        //用户已经明确否认了这一照片数据的应用程序访问
        if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            
            // 无权限 引导去开启
            guard let url = URL(string: UIApplicationOpenSettingsURLString)   else {return}
            if UIApplication.shared.canOpenURL(url) {
                
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    func setup(){
        
        focusView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        focusView.layer.borderColor = UIColor.green.cgColor
        focusView.layer.borderWidth = 1.0
        focusView.backgroundColor = UIColor.clear
        self.view.addSubview(focusView)
        focusView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(focusGesture(tap:)))
        
        self.view.addGestureRecognizer(tap)
        
        flashBtn.setImage(UIImage(named: "闪光灯-关"), for: UIControlState.normal)
        isFlashOn = false
    }
    
    func initCamera(){
        
        //使用AVMediaType.video 指明self.device 代表视频 默认使用后置摄像头进行初始化
        self.device = AVCaptureDevice.default(for: AVMediaType.video)
        
        //使用设备初始化输入
        self.inputDevice = try? AVCaptureDeviceInput(device: self.device)
        
        //生成输出对象
        self.output = AVCaptureMetadataOutput()
        self.imageOutPut = AVCaptureStillImageOutput()
        
        //生成会话，用来结合输出
        self.session = AVCaptureSession()
        
        if self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")){
            
            self.session.sessionPreset = AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")
        }
        
        if self.session.canAddInput(self.inputDevice!){
            self.session.addInput(self.inputDevice!)
        }
        
        if self.session.canAddOutput(self.imageOutPut){
            
            self.session.addOutput(self.imageOutPut)
        }
        
        //使用 self.session. 初始化预览层  self.session负责驱动input信息采集layer
        //负责把图像渲染显示
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(self.previewLayer, below: self.photoButton.layer)
        
        //开始启动
        self.session.startRunning()
        
        
        
        if (try? device.lockForConfiguration()) != nil {
            
           
            if device.isFlashModeSupported(.auto){
                
                device.flashMode = .auto
            }
            
            //自动白平衡
            if device.isWhiteBalanceModeSupported(.autoWhiteBalance){
                
                device.whiteBalanceMode = .autoWhiteBalance
            }
            
            if !device.hasFlash {return}
            
            if device.flashMode == .on || device.flashMode == .off {
                
                device.flashMode = .off
                self.isFlashOn = false
            }
            
           device.unlockForConfiguration()
        }

    }
    
    @objc func focusGesture(tap : UITapGestureRecognizer){
        
    }
}
