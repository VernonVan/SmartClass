//
//  pptView.swift
//  SmartClass
//
//  Created by Vernon on 15/8/31.
//  Copyright (c) 2015年 Vernon. All rights reserved.
//

import UIKit
import Toast

class PPTView: UIWebView , UIWebViewDelegate
{
    private var totalPage = 0
    private var currentPage = 0
    
    var gestureView: UIView?
    var canvasView: CanvasView?
    
    init(frame: CGRect , pptURL: NSURL)
    {
        super.init(frame: frame)
        
        delegate = self
        loadRequest(NSURLRequest(URL: pptURL))
        
        gestureView = UIView(frame: bounds)
        addGestureOntoGestureView()
        addSubview(gestureView!)
        
        canvasView = CanvasView(frame: bounds)
        canvasView!.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIWebView Delegate
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        totalPage = Int(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('slide').length")!)!
        currentPage = 0

        let pptViewHeight = frame.size.height
        let pptViewWidth = frame.size.width

        for i in 0 ..< totalPage {
            webView.stringByEvaluatingJavaScriptFromString(String(format: "var ppt_width=document.getElementsByClassName('slide')[%d].style.width.replace('px','') ; var percent = %f / ppt_width ; var ppt_height=document.getElementsByClassName('slide')[%d].style.height.replace('px','') * percent  ;   var pptspaceheight=(%f -ppt_height)/2 ; document.getElementsByClassName('slide')[%d].style.top = pptspaceheight + 'px' ; document.body.style.background='black';", i, pptViewWidth, i, pptViewHeight, i))
            if i != 0 {
                webView.stringByEvaluatingJavaScriptFromString(String(format: "document.getElementsByClassName('slide')[%d].style.display='none';", i))
            }
        }
        scrollView.scrollEnabled = false
        
        let timer = NSTimer(timeInterval: 10, target: self, selector: #selector(snap), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func snap()
    {
        snapshotViewAfterScreenUpdates(true)
    }
    
    // MARK: - gesture
    
    func addGestureOntoGestureView()
    {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(pageDown))
        swipeLeftGesture.direction = .Left
        gestureView!.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(pageUp))
        swipeRightGesture.direction = .Right
        gestureView!.addGestureRecognizer(swipeRightGesture)
    }
    
    func pageUp()
    {
        if currentPage == 0 {
            superview?.makeToast(NSLocalizedString("已经到达首页", comment: ""), duration: 0.15, position: CSToastPositionCenter)
            return
        } else {
            stringByEvaluatingJavaScriptFromString(String(format: "document.getElementsByClassName('slide')[%d].style.display='none';", currentPage))
            currentPage -= 1
            stringByEvaluatingJavaScriptFromString(String(format: "document.getElementsByClassName('slide')[%d].style.display='block';", currentPage))

        }
    }

    func pageDown()
    {
        if currentPage == totalPage-1 {
            superview?.makeToast(NSLocalizedString("已经到达尾页", comment: ""), duration: 0.15, position: CSToastPositionCenter)
            return
        } else {
            stringByEvaluatingJavaScriptFromString(String(format: "document.getElementsByClassName('slide')[%d].style.display='none';", currentPage))
            currentPage += 1
            stringByEvaluatingJavaScriptFromString(String(format: "document.getElementsByClassName('slide')[%d].style.display='block';", currentPage))
        }
    }
    
    // MARK: - change state
    
    func canvasState()
    {
        gestureView?.removeFromSuperview()
        addSubview(canvasView!)
    }
    
    func playState()
    {
        canvasView?.removeFromSuperview()
        canvasView?.clearCanvas()
        addSubview(gestureView!)
    }
    
    // MARK: - canvas view
    
    func getCanvasColor() -> UIColor
    {
        return canvasView!.canvasColor
    }
    
    func getCanvasSize() -> Double
    {
        return canvasView!.canvasSize
    }
    
    func getCanvasAlpha() -> Float
    {
        return canvasView!.canvasAlpha
    }
    
    func setCanvasColor(color: UIColor)
    {
        canvasView?.canvasColor = color
    }
    
    func setCanvasSize(size: Double)
    {
        canvasView?.canvasSize = size
    }
    
    func setCanvasAlpha(alpha: Float)
    {
        canvasView?.canvasAlpha = alpha
    }
    
}
