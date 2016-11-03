//
//  PPTViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
//import ShowFramework

protocol CanvasPopoverDelegate
{
    func changeCanvasSize(_ size: Double)
    func changeCanvasColor(_ color: UIColor)
    func changeCanvasAlpha(_ alpha: Float)
}

class PPTViewController: UIViewController, UIPopoverPresentationControllerDelegate, CanvasPopoverDelegate
{
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    var pptURL: URL?
    var isCanvas = false
    var isShowToolbar = false {
        didSet {
            if isShowToolbar == false {
                UIView.animate(withDuration: 0.2, animations: {
                    self.toolbarBottomConstraint.constant -= 44
                })
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: UIViewAnimationOptions(), animations: {
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        view.addSubview(pptView)
        view.addSubview(toolbar)
    }

    
    override var shouldAutorotate : Bool
    {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation
    {
        return .landscapeRight
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return [.landscapeRight, .landscapeLeft]
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func canvasAction(_ sender: UIBarButtonItem)
    {
        isCanvas = !isCanvas
        if isCanvas {
            toolbar.items![3].tintColor = ThemeGreenColor
            pptView.canvasState()
            performSegue(withIdentifier: "canvasPopover", sender: sender)
        } else {
            toolbar.items![3].tintColor = UIColor.white
            pptView.playState()
        }
    }
    
    func showToolbarOrNot()
    {
        isShowToolbar = !isShowToolbar
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "canvasPopover" {
            let popoverViewController = segue.destination as! CanvasPopoverViewController
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
            
            popoverViewController.color = pptView.getCanvasColor()
            popoverViewController.size = pptView.getCanvasSize()
            popoverViewController.alpha = pptView.getCanvasAlpha()
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    
    // MARK: - CanvasPopoverDelegate
    
    func changeCanvasSize(_ size: Double)
    {
        pptView.setCanvasSize(size)
    }
    
    func changeCanvasColor(_ color: UIColor)
    {
        pptView.setCanvasColor(color)
    }
    
    func changeCanvasAlpha(_ alpha: Float)
    {
        pptView.setCanvasAlpha(alpha)
    }
    
}
