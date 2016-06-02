//
//  PreviewRootViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/5/24.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PreviewRootViewController: UIViewController
{
    var paper: Paper?
    lazy var questionNumber: Int = {
        return self.paper?.questions?.count ?? 0
    }()
    var pageViewControllers = NSMutableArray()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let controllers = NSMutableArray()
        for _ in 0 ..< questionNumber {
            controllers.addObject(NSNull())
        }
        pageViewControllers = controllers

        scrollView.scrollsToTop = false
        scrollView.delegate = self
        
        pageControl.numberOfPages = questionNumber
        pageControl.currentPage = 0
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: CGRectGetWidth(scrollView.frame) * CGFloat(questionNumber), height: CGRectGetHeight(scrollView.frame))
        
        loadScrollViewWithPage(0)
        loadScrollViewWithPage(1)
    }
    
    func loadScrollViewWithPage(page: Int)
    {
        if page >= questionNumber || page < 0 {
            return
        }
        
        var controller = pageViewControllers[page] as? PreviewPaperViewController
        if controller == nil {
            controller = PreviewPaperViewController(question: paper?.questions?[page] as? Question)
            pageViewControllers.replaceObjectAtIndex(page, withObject: controller!)
        }
        
        if controller?.view.superview == nil {
            var frame = scrollView.frame
            frame.origin.x = CGRectGetWidth(frame) * CGFloat(page)
            frame.origin.y = 0
            controller?.view.frame = frame
            
            addChildViewController(controller!)
            scrollView.addSubview(controller!.view)
            controller?.didMoveToParentViewController(self)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        scrollView.contentSize = CGSize(width: CGRectGetWidth(scrollView.frame) * CGFloat(questionNumber), height: CGRectGetHeight(scrollView.frame))
        pageViewControllers.removeAllObjects()
        let controllers = NSMutableArray()
        for _ in 0 ..< questionNumber {
            controllers.addObject(NSNull())
        }
        pageViewControllers = controllers
        
        loadScrollViewWithPage(pageControl.currentPage - 1)
        loadScrollViewWithPage(pageControl.currentPage)
        loadScrollViewWithPage(pageControl.currentPage + 1)
        
        gotoPage(false)
    }
    
    func gotoPage(animated: Bool)
    {
        let page = pageControl.currentPage
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)
        
        var bounds = scrollView.bounds
        bounds.origin.x = CGRectGetWidth(bounds) * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)
    }
    
    @IBAction func changePageAction()
    {
        gotoPage(true)
    }
    
}

extension PreviewRootViewController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let pageWidth = CGRectGetWidth(self.scrollView.frame)
        let page = Int(floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1)
        pageControl.currentPage = page
        
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)
    }
}
