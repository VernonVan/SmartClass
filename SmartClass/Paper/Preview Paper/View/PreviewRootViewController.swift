//
//  PreviewRootViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/5/24.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class PreviewRootViewController: UIViewController
{
    var paper: Paper?
    
    var questions: Results<Question>?
    
    lazy var questionNumber: Int = {
        return self.paper!.questions.count
    }()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var pageViewControllers = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        let controllers = NSMutableArray()
        for _ in 0 ..< questionNumber {
            controllers.add(NSNull())
        }
        pageViewControllers = controllers

        scrollView.scrollsToTop = false
        scrollView.delegate = self
        
        pageControl.numberOfPages = questionNumber
        pageControl.currentPage = 0
        
        questions = paper?.questions.sorted(byProperty: "index")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(questionNumber), height: scrollView.frame.height)
        
        loadScrollViewWithPage(0)
        loadScrollViewWithPage(1)
    }
    
    func loadScrollViewWithPage(_ page: Int)
    {
        if page >= questionNumber || page < 0 {
            return
        }
        
        var controller = pageViewControllers[page] as? PreviewPaperViewController
        if controller == nil {
            controller = PreviewPaperViewController(question: questions?[page])
            pageViewControllers.replaceObject(at: page, with: controller!)
        }
        
        if controller?.view.superview == nil {
            var frame = scrollView.frame
            frame.origin.x = frame.width * CGFloat(page)
            frame.origin.y = 0
            controller?.view.frame = frame
            
            addChildViewController(controller!)
            scrollView.addSubview(controller!.view)
            controller?.didMove(toParentViewController: self)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(questionNumber), height: scrollView.frame.height)
        pageViewControllers.removeAllObjects()
        let controllers = NSMutableArray()
        for _ in 0 ..< questionNumber {
            controllers.add(NSNull())
        }
        pageViewControllers = controllers
        
        loadScrollViewWithPage(pageControl.currentPage - 1)
        loadScrollViewWithPage(pageControl.currentPage)
        loadScrollViewWithPage(pageControl.currentPage + 1)
        
        gotoPage(false)
    }
    
    func gotoPage(_ animated: Bool)
    {
        let page = pageControl.currentPage
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)
        
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageWidth = self.scrollView.frame.width
        let page = Int(floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1)
        pageControl.currentPage = page
        
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)
    }
}
