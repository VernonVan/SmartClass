//
//  PPTDisplayViewController.swift
//  SmartClass
//
//  Created by 至开 郑 on 16/10/27.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PPTDisplayViewController: UIViewController,UIWebViewDelegate,VCSessionDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var PPTwebView: UIWebView!
    var pptURL: NSURL?
    var PictureAddressArray:NSMutableArray?
    var livechannel:LiveChannel?
    var user:User?
    var session:VCSimpleSession?
    var streamKey:LiveStreamKey?
    var grayView:UIView?
    var didLogin:Bool?
    var didPause:Bool?
    var didPPTLoad:Bool?
    var didPPT:Bool?
    var didStart:Bool?
    var page:Int?
    var nowPage:Int?
    var baseNumber:NSInteger?
    var selectResolutionTableViewDataSource:SelectResolutionTableViewDataSource?
    var RTMPAddress:NSString?
    var watchingAddress:NSString?
    var _baseNumber:CGFloat = 2;
    //    var activity:UIActivity?
    var pptString:NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        beginButton.hidden = false
        nextButton.hidden = true
        previousButton.hidden = true
        backButton.hidden = true
        didStart = false
        user=User.sharedUser()
        streamKey = LiveStreamKey.init()
        user?.userName = "ppt"
        user?.password = "ppt"
        if(NSUserDefaults.standardUserDefaults().objectForKey("cn.scnu.edu.liveusername")==nil)
        {
            //            [self loadLoginFrame];
            //            _btnConnect.alpha = 0;
            //            _btnFilter.alpha = 0;
            //            _btnSwitchCam.alpha = 0;
            //            _selectResolutionContainerView.alpha = 0;
            //            _addressInputButton.alpha = 0;
            //            _watchingPreviewButton.alpha = 0;
        }
        else
        {
            user?.userName = NSUserDefaults.standardUserDefaults().objectForKey("cn.scnu.edu.liveusername")as! String
            user?.password = NSUserDefaults.standardUserDefaults().objectForKey("cn.scnu.edu.livepassword")as! String
            didLogin = true
        }
        streamKey?.userName = user?.userName
        print(streamKey?.userName)
        streamKey?.resolution = "360p"
//        print(streamKey?.resolution)
        streamKey?.date = NSString.init(string: self.getTodaysDate()) as String
        streamKey?.channel = NSString.init(string: "channel1") as String
        self.getTodaysDate()
//        print(streamKey?.date)
        RTMPAddress = LIVE_URL
        RTMPAddress = NSUserDefaults.standardUserDefaults().objectForKey("cn.edu.scnu.rtmpaddress")as? NSString
        if(RTMPAddress == ""||RTMPAddress==nil)
        {
            RTMPAddress = LIVE_URL;
        }
        watchingAddress = NSUserDefaults.standardUserDefaults().objectForKey("cn.edu.scnu.watchingaddress")as? NSString
        livechannel = LiveChannel.init(URL: RTMPAddress as! String, andStreamKey: streamKey)
        
        //        _selectResolutionTableViewDataSource = [[SelectResolutionTableViewDataSource alloc] init];
        //        _selectResolutionTableViewDataSource.configureCellBlock = ^(UITableViewCell *cell, id item) {
        //            NSString *string = (NSString *)item;
        //            cell.textLabel.text = string;
        //        };
        //            _selectResolutionTableView.dataSource = _selectResolutionTableViewDataSource;
        //            _selectResolutionTableView.delegate = self;
        //            _selectResolutionTableView.alpha = 0;
        //            _selectResolutionButton.layer.cornerRadius = 5;
        //            _addressInputButton.layer.cornerRadius = 5;
        //            _watchingPreviewButton.layer.cornerRadius = 5;
        //            _PPTwebView.hidden = true;
        //            _previous.hidden = true;
        //            _next.hidden = true;
        didPause = false
        didStart = false
        didPPT = false
        PPTwebView.delegate = self;
        PictureAddressArray = NSMutableArray.init(capacity: 10)
        
        nowPage = 1
        //        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //        [activity setCenter:CGPointMake(self.view.bounds.size.height/2, self.view.bounds.size.width/2)];
        //        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //        [self.view addSubview:activity];
        //        [activity startAnimating];
        print(watchingAddress,RTMPAddress)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadppt(pptURL!)
        didPPTLoad = true
        self.setupSessionWithVideoSize(CGSizeMake(1280, 720), frameRate: 25, bitrate: 1000000, userInterfaceOrientation: false, cameraState: VCCameraState.Back)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //获取时间用于观看网址
    func getTodaysDate() -> NSString
    {
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter? = NSDateFormatter.init()
        formatter!.dateFormat = "yyyyMMdd"
        print(date)
        print(formatter!.stringFromDate(date))
        return (formatter!.stringFromDate(date))
    }
    
    //加载PPT
    func loadppt(path:NSURL)
    {
        PPTwebView.delegate = self
        let request:NSURLRequest = NSURLRequest.init(URL: path)
        PPTwebView.scalesPageToFit = true
        PPTwebView.loadRequest(request)
        print (request)
    }
    
    //前一页PPT
    func previousPPT()
    {
        if nowPage! != 1 {
            let picturePath:NSString = PictureAddressArray![nowPage!-2] as! NSString
            let PPTs:UIImage = UIImage.init(contentsOfFile: picturePath as String)!
            self.addPPT(PPTs, num: Int32(nowPage!-1))
            session?.removePixelBufferSource(Int32(nowPage!))
            nowPage! -= 1
        }
        else
        {
            let title:NSString = NSLocalizedString("读取PPT出错", comment: "")
            let message:NSString = NSLocalizedString("没有上一页了", comment: "")
            self.PushWarning(title, message: message)
        }
    }
    
    //下一页PPT
    func nextPPT()
    {
        if nowPage<PictureAddressArray?.count {
            let picture:UIImage = UIImage.init(contentsOfFile: PictureAddressArray![nowPage!] as! String)!
            self.addPPT(picture, num: nowPage!+1)
            session?.removePixelBufferSource(Int32(nowPage!))
            nowPage! += 1
        }
        else
        {
            let title:NSString = NSLocalizedString("读取PPT出错", comment: "")
            let message:NSString = NSLocalizedString("没有下一页了", comment: "")
            self.PushWarning(title, message: message)
        }
    }
    //
    //    - (IBAction)nextButton:(id)sender {
    //    if (_nowPage < _PictureAddressArray.count) {
    //    UIImage *picture = [UIImage imageWithContentsOfFile:_PictureAddressArray[_nowPage]];
    //    [self addPPT:picture withNum:_nowPage+1];
    //    [_session removePixelBufferSource:_nowPage];
    //    [self setLogo];
    //    _nowPage++;
    //
    //    }
    //    else
    //    {
    //    NSString *title = NSLocalizedString(@"读取PPT出错", nil);
    //    NSString *message = NSLocalizedString(@"没有下一页了", nil);
    //    [self PushWarning:title withmessage:message];
    //    }
    //    }
    
    //webview完成load后切PPT
    func webViewDidFinishLoad(webView: UIWebView) {
        self.generateThumbnailForAllSlides()
        webView.removeFromSuperview()
        let white:UIImage? = UIImage.init(named: "white")
        session?.addPixelBufferSource(white, withRect: CGRectMake(500, 300, 10000, 10000), withNum: 0)
        self.view.insertSubview(session!.previewView, atIndex: 0)
        session!.previewView.frame = self.view.bounds
        session!.delegate = self
        //        _webView = nil;
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
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
        let slideCount = (PPTwebView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('slide').length")!as NSString).integerValue
        //循环生成缩略图
        print(PPTwebView)
        for slideIndex in 0 ..< slideCount
        {
            let height = (PPTwebView.stringByEvaluatingJavaScriptFromString(NSString.init(format: "document.getElementsByClassName('slide')[%d].style.height", slideIndex)as String)!as NSString).integerValue
            let width = (PPTwebView.stringByEvaluatingJavaScriptFromString(NSString.init(format: "document.getElementsByClassName('slide')[%d].style.width", slideIndex)as String)!as NSString).integerValue
            //            print(height,width)
            var bounds:CGRect = PPTwebView.bounds
            bounds.size.width = 960
            bounds.size.height = CGFloat.init(height*Int(PPTwebView.bounds.size.width)/width)
            let scale:CGFloat = CGFloat(Float(PPTwebView.bounds.size.width)/Float(width))
            let offset:Int = Int(PPTwebView.stringByEvaluatingJavaScriptFromString(NSString.init(format: "document.getElementsByClassName('slide')[%d].offsetTop", slideIndex)as String)!)!
            var so:CGPoint = PPTwebView.scrollView.contentOffset;
            so.y = CGFloat(offset) * scale
            PPTwebView.scrollView.contentOffset = so;
            UIGraphicsBeginImageContext(bounds.size);
            PPTwebView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let slideThumbnailImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let filename:NSString = NSString.init(format: "slide%i.png", slideIndex)
            let documentsPaths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let outputImagePath:NSString = documentsPaths.objectAtIndex(0).stringByAppendingPathComponent(filename as String)
            UIImagePNGRepresentation(slideThumbnailImage!)?.writeToFile(outputImagePath as String, atomically: true)
            PictureAddressArray?.addObject(outputImagePath)
        }
    }
    
    func connectionStatusChanged(sessionState: VCSessionState) {
    }
    
    
    func didAddCameraSource(session: VCSimpleSession!) {
        session.continuousAutofocus = false
    }
    
    //增加PPT
    func addPPT(image:UIImage,num:Int32)
    {
        let modelname:NSString = UIDevice.currentDevice().model
        if(modelname.isEqualToString("iPad"))
        {
            session?.addPixelBufferSource(image, withRect: CGRectMake(465 * _baseNumber, 180 * _baseNumber,770 * _baseNumber, 380 * _baseNumber), withNum:num)
        }
        if(modelname.isEqualToString("iPod touch"))
        {
            session?.addPixelBufferSource(image, withRect: CGRectMake(480 * _baseNumber, 180 * _baseNumber,860 * _baseNumber, 380 * _baseNumber), withNum:num)
        }
        if(modelname.isEqualToString("iPhone"))
        {
            session?.addPixelBufferSource(image, withRect: CGRectMake(480 * _baseNumber, 180 * _baseNumber,860 * _baseNumber, 380 * _baseNumber), withNum:num)
        }
    }
    
    //Pushing错误警告
    func PushWarning(title:NSString,message:NSString)
    {
        let okButtonTitle:NSString = NSLocalizedString("我知道了", comment: "")
        let alertController:UIAlertController = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction:UIAlertAction = UIAlertAction.init(title: okButtonTitle as String, style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("")})
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    override func shouldAutorotate() -> Bool {
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
    
    
    @IBAction func playButton(sender: AnyObject) {
        didStart = true
        livechannel?.updateGeneratedStreamKey()
        session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey)
        print(PictureAddressArray)
        let picturePath:NSString? = PictureAddressArray![nowPage!-1] as? NSString
        let PPTs:UIImage? = UIImage.init(contentsOfFile: picturePath as! String)!
        self.addPPT(PPTs!, num: 1)
        beginButton.hidden = true
        backButton.hidden = false
        nextButton.hidden = false
        previousButton.hidden = false
//        if session?.rtmpSessionState == VCSessionState.None {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(1);livechannel?.updateGeneratedStreamKey()
//        }
//        if session?.rtmpSessionState == VCSessionState.Started {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(2);livechannel?.updateGeneratedStreamKey()
//        }
//        if session?.rtmpSessionState == VCSessionState.Starting {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(3);livechannel?.updateGeneratedStreamKey()
//        }
//        if session?.rtmpSessionState == VCSessionState.PreviewStarted {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(4);livechannel?.updateGeneratedStreamKey()
//        }
//        if session?.rtmpSessionState == VCSessionState.Ended {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(5);livechannel?.updateGeneratedStreamKey()
//        }
//        if session?.rtmpSessionState == VCSessionState.Error {
//            session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(6);livechannel?.updateGeneratedStreamKey()
//        }
//        switch session?.rtmpSessionState {
//        case .VCSessionStateNone:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(1)
//        default:
//        }
//        switch session!.rtmpSessionState {
//        case .VCSessionStateNone:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(1)
//        case VCSessionState.Started:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(2)
//        case VCSessionState.Ended:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(3)
//        case VCSessionState.Error:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(4)
//        case VCSessionState.Starting:session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey);print(5)
//            break
//        default:print(6);session?.endRtmpSession()
//        print(session?.rtmpSessionState)
//        }
        //        switch (_session.rtmpSessionState) {
        //        case VCSessionStateNone:
        //        case VCSessionStatePreviewStarted:
        //        case VCSessionStateEnded:
        //        case VCSessionStateError:
        //            [_livechannel updateGeneratedStreamKey];
        //            [_session startRtmpSessionWithURL:_livechannel.url andStreamKey:_livechannel.streamKey];
        //            _didStart = YES;
        //            break;
        //        default:
        //            [_session endRtmpSession];
        //            _didStart = NO;
        //            break;
        //        }
        
    }
    
    @IBAction func PreviousButton(sender: AnyObject) {
        if (didStart == true) {
            self.previousPPT()
        }
        else
        {
            let title:NSString = NSLocalizedString("出错", comment: "")
            let message:NSString = NSLocalizedString("PPT未加载", comment: "")
            self.PushWarning(title, message: message)
        }
    }
    
    
    @IBAction func NextButton(sender: AnyObject) {
        if (didStart == true) {
            self.nextPPT()
        }
        else
        {   let title:NSString = NSLocalizedString("出错", comment: "")
            let message:NSString = NSLocalizedString("PPT未加载", comment: "")
            self.PushWarning(title, message: message)
        }
        
    }
    
    @IBAction func BackButton(sender: AnyObject) {
        session?.removePixelBufferSource(Int32(nowPage!))
        session?.endRtmpSession()
        dismissViewControllerAnimated(false, completion: nil)
    }

    
//    @IBAction func Pre_button(sender: AnyObject) {
//        didStart = true
//        livechannel?.updateGeneratedStreamKey()
//        session?.startRtmpSessionWithURL(livechannel?.url, andStreamKey: livechannel?.streamKey)
//        print(PictureAddressArray)
//        let picturePath:NSString? = PictureAddressArray![nowPage!-1] as? NSString
//        let PPTs:UIImage? = UIImage.init(contentsOfFile: picturePath as! String)!
//        print(PPTs)
//        self.addPPT(PPTs!, num: 1)
//        beginButton1.hidden = true
//        backButton.hidden = false
//        nextButton.hidden = false
//        previousButton.hidden = false
//    }
}
