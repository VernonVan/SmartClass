//
//  PPTDisplayViewController.swift
//  SmartClass
//
//  Created by 至开 郑 on 16/10/27.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast

class PPTDisplayViewController: UIViewController, UIWebViewDelegate, VCSessionDelegate
{
    var pptURL: URL?
    var pictureAddressArray: NSMutableArray?
    var livechannel: LiveChannel?
    var streamKey: LiveStreamKey?
    var nowPage: Int?
    var baseNumber: CGFloat = 2

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var onlyShowPPT: UIButton!
    @IBOutlet weak var PPTwebView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        beginButton.isHidden = false
        onlyShowPPT.isHidden = true
        backButton.isHidden = true
        streamKey = LiveStreamKey()
        
        streamKey?.userName = "ppt"
        streamKey?.resolution = "720p"
        streamKey?.date = getTodaysDate()
        streamKey?.channel = "channel1"
        
        let RTMPAddress = LIVE_URL as String
        livechannel = LiveChannel(url: RTMPAddress, andStreamKey: streamKey)
        PPTwebView.delegate = self
        pictureAddressArray = NSMutableArray(capacity: 10)
        nowPage = 1
    }
    
    let session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 25, bitrate: 1000000, useInterfaceOrientation: false, cameraState: .back)!
    
    override func viewDidAppear(_ animated: Bool)
    {
        spinner.startAnimating()
        beginButton.isUserInteractionEnabled = false
        beginButton.titleLabel?.text = "正在加载"
        loadppt(path: pptURL!)
    }
    
    // 获取时间用于观看网址
    func getTodaysDate() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }
    
    // 加载PPT
    func loadppt(path: URL)
    {
        PPTwebView.delegate = self
        let request = URLRequest(url: path)
        PPTwebView.scalesPageToFit = true
        PPTwebView.loadRequest(request)
    }
    
    lazy var leftSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self,action: #selector((handleSwipes)))
        leftSwipeGestureRecognizer.direction = .left
        return leftSwipeGestureRecognizer
    }()
    
    lazy var rightSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self,action: #selector((handleSwipes)))
        rightSwipeGestureRecognizer.direction = .right
        return rightSwipeGestureRecognizer
    }()
    
    // webview完成load后切PPT
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        generateThumbnailForAllSlides()
        webView.removeFromSuperview()
        let white = UIImage(named: "white")
        session.addPixelBufferSource(white, with: CGRect(x: 500, y: 300, width: 10000, height: 10000), withNum: 0)
        view.insertSubview(session.previewView, at: 0)
        session.previewView.frame = self.view.bounds
        session.delegate = self
        beginButton.titleLabel?.text = "开始演示PPT"
        spinner.stopAnimating()
        spinner.isHidden = true
        beginButton.isUserInteractionEnabled = true
        onlyShowPPT.isHidden = false
        backButton.isHidden = false
    }
    
    // 循环生成缩略图
    func generateThumbnailForAllSlides()
    {
        let slideCount = (PPTwebView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('slide').length")!as NSString).integerValue
        for slideIndex in 0 ..< slideCount {
            let height = (PPTwebView.stringByEvaluatingJavaScript(from: NSString(format: "document.getElementsByClassName('slide')[%d].style.height", slideIndex) as String)! as NSString).integerValue
            let width = (PPTwebView.stringByEvaluatingJavaScript(from: NSString(format: "document.getElementsByClassName('slide')[%d].style.width", slideIndex) as String)! as NSString).integerValue
            var bounds = PPTwebView.bounds
            bounds.size.width = 960
            bounds.size.height = CGFloat.init(height*Int(PPTwebView.bounds.size.width)/width)
            let scale = CGFloat(Float(PPTwebView.bounds.size.width)/Float(width))
            let offset = Int(PPTwebView.stringByEvaluatingJavaScript(from: NSString.init(format: "document.getElementsByClassName('slide')[%d].offsetTop", slideIndex)as String)!)!
            var so = PPTwebView.scrollView.contentOffset;
            so.y = CGFloat(offset) * scale
            PPTwebView.scrollView.contentOffset = so;
            if (pptURL?.pathExtension.contains("ppt"))! && !(pptURL?.pathExtension.contains("pptx"))!
            {
                UIGraphicsBeginImageContext(bounds.size);
            } else {
                UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            }
            PPTwebView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let slideThumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let filename = NSString(format: "slide%i.png", slideIndex)
            let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let outputImagePath: String = (documentsPaths.object(at: 0) as AnyObject).appendingPathComponent(filename as String)
            let data = UIImagePNGRepresentation(slideThumbnailImage!)! as NSData
            data.write(toFile: outputImagePath, atomically: true)
            pictureAddressArray?.add(outputImagePath)
        }
    }
    
    func connectionStatusChanged(_ sessionState: VCSessionState)
    {
        
    }
    
    func didAddCameraSource(_ session: VCSimpleSession!)
    {
        session.continuousAutofocus = false
    }

    @IBAction func playButton(_ sender: AnyObject)
    {
        session.previewView.addGestureRecognizer(leftSwipeGestureRecognizer)
        session.previewView.addGestureRecognizer(rightSwipeGestureRecognizer)
        livechannel?.updateGeneratedStreamKey()
        let picturePath:NSString? = pictureAddressArray![nowPage!-1] as? NSString
        let PPT = UIImage(contentsOfFile: picturePath as! String)!
        self.addPPT(image: PPT, num: 1)
        session.startRtmpSession(withURL: livechannel?.url, andStreamKey: livechannel?.streamKey)
        beginButton.isHidden = true
        onlyShowPPT.isHidden = true
        
    }

    @IBAction func BackButton(_ sender: AnyObject)
    {
        session.removePixelBufferSource(Int32(nowPage!))
        session.endRtmpSession()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func ShowButton(_ sender: AnyObject)
    {
        session.previewView.addGestureRecognizer(leftSwipeGestureRecognizer)
        session.previewView.addGestureRecognizer(rightSwipeGestureRecognizer)
        let picturePath:NSString? = pictureAddressArray![nowPage!-1] as? NSString
        let PPT = UIImage(contentsOfFile: picturePath as! String)!
        self.addPPT(image: PPT, num: 1)
        onlyShowPPT.isHidden = true
        beginButton.isHidden = true
    }
    
    // 手势方法
    func handleSwipes(gesture: UISwipeGestureRecognizer)
    {
        if gesture.direction == .right {
            if nowPage! != 1 {
                let PPT = UIImage(contentsOfFile: pictureAddressArray![nowPage!-2] as! String)!
                session.removePixelBufferSource(Int32(nowPage!))
                addPPT(image: PPT, num: Int32(nowPage!-1))
                nowPage! -= 1
            } else {
                view.makeToast("已经到达首页", duration: 0.15, position: CSToastPositionCenter)
            }
        } else if gesture.direction == .left {
            if nowPage! < (pictureAddressArray?.count)! {
                let picture = UIImage(contentsOfFile: pictureAddressArray![nowPage!] as! String)!
                session.removePixelBufferSource(Int32(nowPage!))
                addPPT(image: picture, num: nowPage!+1)
                                nowPage! += 1
            } else {
                view.makeToast("已经到达尾页", duration: 0.15, position: CSToastPositionCenter)
            }
        }
    }
    
    // 增加PPT
    func addPPT(image: UIImage, num: Int32)
    {
        let modelName = UIDevice.current.model
        if modelName == "iPad" {
            session.addPixelBufferSource(image, with: CGRect(x: 465 * baseNumber, y: 180 * baseNumber, width: 770 * baseNumber, height: 380 * baseNumber), withNum:num)
        } else if modelName == "iPod touch" {
            session.addPixelBufferSource(image, with: CGRect(x: 480 * baseNumber, y: 180 * baseNumber, width: 860 * baseNumber, height: 380 * baseNumber), withNum:num)
        } else if modelName == "iPhone" {
            session.addPixelBufferSource(image, with: CGRect(x: 480 * baseNumber, y: 180 * baseNumber, width: 860 * baseNumber, height: 380 * baseNumber), withNum: num)
        }
    }
    
    // 强制横屏
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return .landscapeRight
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return [.landscapeRight, .landscapeLeft]
    }
}
