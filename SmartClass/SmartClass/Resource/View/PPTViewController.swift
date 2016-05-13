//
//  PPTViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import SnapKit

protocol CanvasPopoverDelegate
{
    func changeCanvasSize(size: Double)
    func changeCanvasColor(color: UIColor)
    func changeCanvasAlpha(alpha: Float)
}

class PPTViewController: UIViewController, UIPopoverPresentationControllerDelegate, CanvasPopoverDelegate
{
    var pptURL: NSURL?
    var isCanvas = false
    var isShowToolbar = false {
        didSet {
            if isShowToolbar == false {
                UIView.animateWithDuration(0.1, animations: {
                    var toolbarFrame = self.toolbar.frame
                    toolbarFrame.origin.y += 44
                    self.toolbar.frame = toolbarFrame
                })
            } else {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .CurveEaseInOut, animations: {
                    var toolbarFrame = self.toolbar.frame
                    toolbarFrame.origin.y -= 44
                    self.toolbar.frame = toolbarFrame
                    }, completion: nil)
            }
        }
    }
    
    lazy var pptView: PPTView = {
        let width = self.view.frame.size.width
        let height = width*0.75
        let pptView = PPTView(frame: CGRectZero, pptURL: self.pptURL!)
        pptView.scalesPageToFit = true
        return pptView
    }()

    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.addSubview(pptView)
        adjustViewsForOrientation(UIApplication.sharedApplication().statusBarOrientation)
        
        view.addSubview(toolbar)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showToolbarOrNot))
        isShowToolbar = true
        view.addGestureRecognizer(tapGesture)

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func orientationChanged(notification: NSNotification)
    {
        adjustViewsForOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func adjustViewsForOrientation(orientation: UIInterfaceOrientation)
    {
        var height = view.frame.size.height
        var width = view.frame.size.width
        
        switch orientation {
        case .LandscapeLeft , .LandscapeRight :
            width = (height*4) / 3
            pptView.frame = CGRect(x: (view.frame.size.width-width)/2, y: 0, width: width,  height: height)
        case .Portrait , .PortraitUpsideDown:
            height = width * 0.75
            pptView.frame = CGRect(x: 0, y: (view.frame.size.height-height)/2, width: width,  height: height)
        case .Unknown:
            break
        }
        
        let gestureFrame = CGRect(x: 0, y: 0, width: width, height: height)
        pptView.gestureView!.frame = gestureFrame
        pptView.canvasView?.frame = gestureFrame
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func canvasAction(sender: UIBarButtonItem)
    {
        isCanvas = !isCanvas
        if isCanvas {
            toolbar.items![3].tintColor = ThemeGreenColor
            pptView.canvasState()
            
            performSegueWithIdentifier("canvasPopover", sender: sender)
        } else {
            toolbar.items![3].tintColor = UIColor.whiteColor()
            pptView.playState()
        }
    }
    
    func showToolbarOrNot()
    {
        isShowToolbar = !isShowToolbar
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "canvasPopover" {
            let popoverViewController = segue.destinationViewController as! CanvasPopoverViewController
            popoverViewController.modalPresentationStyle = .Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
            
            popoverViewController.color = pptView.getCanvasColor()
            popoverViewController.size = pptView.getCanvasSize()
            popoverViewController.alpha = pptView.getCanvasAlpha()
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
    
    // MARK: - CanvasPopoverDelegate
    
    func changeCanvasSize(size: Double)
    {
        pptView.setCanvasSize(size)
    }
    
    func changeCanvasColor(color: UIColor)
    {
        pptView.setCanvasColor(color)
    }
    
    func changeCanvasAlpha(alpha: Float)
    {
        pptView.setCanvasAlpha(alpha)
    }
    
}
