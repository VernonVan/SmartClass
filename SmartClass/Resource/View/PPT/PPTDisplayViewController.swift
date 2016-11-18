//
//  PPTDisplayViewController.swift
//  SmartClass
//
//  Created by 至开 郑 on 16/10/27.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PPTDisplayViewController: UIViewController, UIWebViewDelegate, VCSessionDelegate
{
    var pptURL: NSURL?
    var pictureAddressArray: NSMutableArray?
    var livechannel: LiveChannel?
    var user: User?
    var session: VCSimpleSession?
    var streamKey: LiveStreamKey?
    var grayView: UIView?
    var didLogin: Bool?
    var didPause: Bool?
    var didPPTLoad: Bool?
    var didPPT: Bool?
    var didStart: Bool?
    var page: Int?
    var nowPage: Int?
    var baseNumber: NSInteger?
    var selectResolutionTableViewDataSource: SelectResolutionTableViewDataSource?
    var RTMPAddress: NSString?
    var watchingAddress: NSString?
    var _baseNumber: CGFloat = 2;
    var activityIndicator: UIActivityIndicatorView?
    var pptString: NSString?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var PPTWebView: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        beginButton.isHidden = false
        nextButton.isHidden = true
        previousButton.isHidden = true
        backButton.isHidden = true
        didStart = false
        user=User.shared()
        streamKey = LiveStreamKey.init()
        user?.userName = "ppt"
        user?.password = "ppt"
        if(UserDefaults.standard.object(forKey: "cn.scnu.edu.liveusername")==nil)
        {
        }
        else
        {
            user?.userName = UserDefaults.standard.object(forKey: "cn.scnu.edu.liveusername")as! String
            user?.password = UserDefaults.standard.object(forKey: "cn.scnu.edu.livepassword")as! String
            didLogin = true
        }
        streamKey?.userName = user?.userName
        print(streamKey?.userName)
        streamKey?.resolution = "360p"
        streamKey?.date = NSString.init(string: self.getTodaysDate()) as String
        streamKey?.channel = NSString.init(string: "channel1") as String
        RTMPAddress = LIVE_URL as NSString?
        RTMPAddress = UserDefaults.standard.object(forKey: "cn.edu.scnu.rtmpaddress")as? NSString
        if(RTMPAddress == ""||RTMPAddress==nil)
        {
            RTMPAddress = LIVE_URL as NSString?;
        }
        watchingAddress = UserDefaults.standard.object(forKey: "cn.edu.scnu.watchingaddress")as? NSString
        livechannel = LiveChannel.init(url: RTMPAddress as! String, andStreamKey: streamKey)
        didPause = false
        didStart = false
        didPPT = false
        PPTWebView.delegate = self;
        pictureAddressArray = NSMutableArray.init(capacity: 10)
        nowPage = 1
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        activityIndicator?.center = self.view.center
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        beginButton.isUserInteractionEnabled = false
        beginButton.titleLabel?.text = "正在加载"
        print("pptURL: \(pptURL)")
        self.loadppt(path: pptURL!)
        didPPTLoad = true
        self.setupSessionWithVideoSize(size: CGSize.init(width: 1280, height: 720), frameRate: 25, bitrate: 1000000, userInterfaceOrientation: false, cameraState: VCCameraState.back)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //获取时间用于观看网址
    func getTodaysDate() -> NSString
    {
        let date:NSDate = NSDate()
        let formatter:DateFormatter? = DateFormatter.init()
        formatter!.dateFormat = "yyyyMMdd"
        print(date)
        print(formatter!.string(from: date as Date))
        return (formatter!.string(from: date as Date) as NSString)
    }
    
    //加载PPT
    func loadppt(path:NSURL)
    {
        PPTWebView.delegate = self
        let request:NSURLRequest = NSURLRequest.init(url: path as URL)
        PPTWebView.scalesPageToFit = true
        PPTWebView.loadRequest(request as URLRequest)
        print (request)
    }
    
    //前一页PPT
    func previousPPT()
    {
        if nowPage! != 1 {
            let picturePath:NSString = pictureAddressArray![nowPage!-2] as! NSString
            let PPTs:UIImage = UIImage.init(contentsOfFile: picturePath as String)!
            self.addPPT(image: PPTs, num: Int32(nowPage!-1))
            session?.removePixelBufferSource(Int32(nowPage!))
            nowPage! -= 1
        }
        else
        {
            let title:NSString = NSLocalizedString("读取PPT出错", comment: "") as NSString
            let message:NSString = NSLocalizedString("没有上一页了", comment: "") as NSString
            self.PushWarning(title: title, message: message)
        }
    }
    
    //下一页PPT
    func nextPPT()
    {
        if nowPage!<(pictureAddressArray?.count)! {
            let picture:UIImage = UIImage.init(contentsOfFile: pictureAddressArray![nowPage!] as! String)!
            self.addPPT(image: picture, num: nowPage!+1)
            session?.removePixelBufferSource(Int32(nowPage!))
            nowPage! += 1
        }
        else
        {
            let title:NSString = NSLocalizedString("读取PPT出错", comment: "") as NSString
            let message:NSString = NSLocalizedString("没有下一页了", comment: "") as NSString
            self.PushWarning(title: title, message: message)
        }
    }
    
    //webview完成load后切PPT
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.generateThumbnailForAllSlides()
        webView.removeFromSuperview()
        let white:UIImage? = UIImage.init(named: "white")
        print(white)
        session?.addPixelBufferSource(white, with: CGRect.init(x: 500, y: 300, width: 10000, height: 10000), withNum: 0)
        self.view.insertSubview(session!.previewView, at: 0)
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target:self,action:#selector((handleSwipes)))
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target:self,action:#selector((handleSwipes)))
        leftSwipeGestureRecognizer.direction = .left
        rightSwipeGestureRecognizer.direction = .right
        self.session!.previewView.addGestureRecognizer(leftSwipeGestureRecognizer)
        self.session!.previewView.addGestureRecognizer(rightSwipeGestureRecognizer)
        session!.previewView.frame = self.view.bounds
        session!.delegate = self
        activityIndicator?.stopAnimating()
        beginButton.titleLabel?.text = "开始直播PPT";
        beginButton.isUserInteractionEnabled = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print (error)
    }
    
    func setupSessionWithVideoSize(size:CGSize,frameRate:Int32,bitrate:Int32,userInterfaceOrientation:Bool,cameraState:VCCameraState)
    {
        session = VCSimpleSession.init(videoSize: size, frameRate: frameRate, bitrate: bitrate, useInterfaceOrientation: userInterfaceOrientation, cameraState: cameraState)
        
    }
    //循环生成缩略图
    func generateThumbnailForAllSlides()
    {
        //页数统计
        let slideCount = (PPTWebView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('slide').length")!as NSString).integerValue
        //循环生成缩略图
        print(PPTWebView)
        for slideIndex in 0 ..< slideCount
        {
            let height = (PPTWebView.stringByEvaluatingJavaScript(from: NSString.init(format: "document.getElementsByClassName('slide')[%d].style.height", slideIndex)as String)!as NSString).integerValue
            let width = (PPTWebView.stringByEvaluatingJavaScript(from: NSString.init(format: "document.getElementsByClassName('slide')[%d].style.width", slideIndex)as String)!as NSString).integerValue
            //            print(height,width)
            var bounds:CGRect = PPTWebView.bounds
            bounds.size.width = 960
            bounds.size.height = CGFloat.init(height*Int(PPTWebView.bounds.size.width)/width)
            let scale:CGFloat = CGFloat(Float(PPTWebView.bounds.size.width)/Float(width))
            let offset:Int = Int(PPTWebView.stringByEvaluatingJavaScript(from: NSString.init(format: "document.getElementsByClassName('slide')[%d].offsetTop", slideIndex)as String)!)!
            var so:CGPoint = PPTWebView.scrollView.contentOffset;
            so.y = CGFloat(offset) * scale
            PPTWebView.scrollView.contentOffset = so;
            UIGraphicsBeginImageContext(bounds.size);
            PPTWebView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let slideThumbnailImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let filename:NSString = NSString.init(format: "slide%i.png", slideIndex)
            let documentsPaths:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let outputImagePath:String = (documentsPaths.object(at: 0) as AnyObject).appendingPathComponent(filename as String)
            
            let data:NSData = UIImagePNGRepresentation(slideThumbnailImage!)! as NSData
            data.write(toFile: outputImagePath, atomically: true)
            pictureAddressArray?.add(outputImagePath)
        }
    }
    
    func connectionStatusChanged(_ sessionState: VCSessionState) {
        
    }
    
    
    func didAddCameraSource(_ session: VCSimpleSession!) {
        session.continuousAutofocus = false
    }
    
    //增加PPT
    func addPPT(image:UIImage,num:Int32)
    {
        let modelname:NSString = UIDevice.current.model as NSString
        if(modelname.isEqual(to: "iPad"))
        {
            session!.addPixelBufferSource(image, with:CGRect.init(x: 465 * _baseNumber, y: 180 * _baseNumber, width: 770 * _baseNumber, height: 380 * _baseNumber), withNum:num)
        }
        
        if(modelname.isEqual(to: "iPod touch"))
        {
            session!.addPixelBufferSource(image, with:CGRect.init(x: 480 * _baseNumber, y: 180 * _baseNumber, width: 860 * _baseNumber, height: 380 * _baseNumber), withNum:num)
        }
        
        if(modelname.isEqual(to: "iPhone"))
        {
            session?.addPixelBufferSource(image, with:CGRect.init(x: 480 * _baseNumber, y: 180 * _baseNumber, width: 860 * _baseNumber, height: 380 * _baseNumber), withNum: num)
            
        }
        
        
    }
    
    //Pushing错误警告
    func PushWarning(title:NSString,message:NSString)
    {
        let okButtonTitle:NSString = NSLocalizedString("我知道了", comment: "") as NSString
        let alertController:UIAlertController = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction:UIAlertAction = UIAlertAction.init(title: okButtonTitle as String, style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("")})
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //    强制横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func playButton(_ sender: AnyObject) {
        didStart = true
        livechannel?.updateGeneratedStreamKey()
        session?.startRtmpSession(withURL: livechannel?.url, andStreamKey: livechannel?.streamKey)
        print(pictureAddressArray)
        let picturePath:NSString? = pictureAddressArray![nowPage!-1] as? NSString
        let PPTs:UIImage? = UIImage.init(contentsOfFile: picturePath as! String)!
        print (PPTs)
        self.addPPT(image: PPTs!, num: 1)
        beginButton.isHidden = true
        backButton.isHidden = false
        nextButton.isHidden = false
        previousButton.isHidden = false
    }
    
    
    @IBAction func PreviousButton(_ sender: AnyObject) {
        if (didStart == true) {
            self.previousPPT()
        }
        else
        {
            let title:NSString = NSLocalizedString("出错", comment: "") as NSString
            let message:NSString = NSLocalizedString("PPT未加载", comment: "") as NSString
            self.PushWarning(title: title, message: message)
        }
    }
    
    
    @IBAction func NextButton(_ sender: AnyObject) {
        if (didStart == true) {
            self.nextPPT()
        }
        else
        {   let title:NSString = NSLocalizedString("出错", comment: "") as NSString
            let message:NSString = NSLocalizedString("PPT未加载", comment: "") as NSString
            self.PushWarning(title: title, message: message)
        }
        
    }
    
    @IBAction func BackButton(_ sender: AnyObject) {
        session?.removePixelBufferSource(Int32(nowPage!))
        session?.endRtmpSession()
        dismiss(animated: false, completion: nil)
    }
    
    //手势方法
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if sender.direction == .right
        {
            previousPPT()
            //            if nowPage != 1{
            //                let picturePath:NSString = PictureAddressArray![nowPage!-2] as! NSString;
            //                let PPTs:UIImage = UIImage.init(contentsOfFile: picturePath as String)!
            //                self.addPPT(image: PPTs, num: Int32(nowPage!-1))
            //                session!.removePixelBufferSource(Int32(nowPage!-0))
            //                nowPage! -= 1
            //            }
            //            else
            //            {
            //                let title:NSString = NSLocalizedString("读取PPT出错", comment: "") as NSString
            //                let message:NSString = NSLocalizedString("没有上一页了", comment: "")as NSString
            //                self.PushWarning(title: title, message: message)
            //            }
        } else if sender.direction == .left {
            //            if nowPage! < PictureAddressArray!.count {
            //                let picturePath:NSString = PictureAddressArray![nowPage!-2] as! NSString;
            //                let PPTs:UIImage = UIImage.init(contentsOfFile: picturePath as String)!
            //                self.addPPT(image: PPTs, num: Int32(nowPage!+1))
            //                session!.removePixelBufferSource(Int32(nowPage!-0))
            //                nowPage! += 1
            //            } else {
            //                let title:NSString = NSLocalizedString("读取PPT出错", comment: "") as NSString
            //                let message:NSString = NSLocalizedString("没有下一页了", comment: "")as NSString
            //                self.PushWarning(title: title, message: message)
            //            }
            
            if nowPage!<(pictureAddressArray?.count)! {
                let picture:UIImage = UIImage.init(contentsOfFile: pictureAddressArray![nowPage!] as! String)!
                self.addPPT(image: picture, num: nowPage!+1)
                session?.removePixelBufferSource(Int32(nowPage!))
                nowPage! += 1
            }
            else
            {
                let title:NSString = NSLocalizedString("读取PPT出错", comment: "") as NSString
                let message:NSString = NSLocalizedString("没有下一页了", comment: "") as NSString
                self.PushWarning(title: title, message: message)
            }
            
        }
    }
    
}
