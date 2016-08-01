//
//  PPTViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

protocol CanvasPopoverDelegate
{
    func changeCanvasSize(size: Double)
    func changeCanvasColor(color: UIColor)
    func changeCanvasAlpha(alpha: Float)
}

class PPTViewController: UIViewController, UIPopoverPresentationControllerDelegate, CanvasPopoverDelegate
{
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    var pptURL: NSURL?
    var isCanvas = false
    var isShowToolbar = false {
        didSet {
            if isShowToolbar == false {
                UIView.animateWithDuration(0.2, animations: {
                    self.toolbarBottomConstraint.constant -= 44
                })
            } else {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .CurveEaseInOut, animations: {
                    self.toolbarBottomConstraint.constant += 44
                    }, completion: nil)
            }
        }
    }
    
    lazy var pptView: PPTView = {
        let height = self.view.frame.size.height
        let width = height * (4/3)
        let pptView = PPTView(frame: CGRect(x: (self.view.frame.size.width - width) / 2, y: 0.0, width: width, height: height), pptURL: self.pptURL!)
        pptView.scalesPageToFit = true
        return pptView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showToolbarOrNot))
        isShowToolbar = true
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        view.addSubview(pptView)
        view.addSubview(toolbar)
    }

    
    override func shouldAutorotate() -> Bool
    {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return .LandscapeRight
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return [.LandscapeRight, .LandscapeLeft]
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
