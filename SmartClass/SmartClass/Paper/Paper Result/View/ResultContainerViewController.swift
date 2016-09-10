//
//  ResultContainerViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/8/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ResultContainerViewController: UIViewController
{
    var paper: Paper?
    
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var chartContainerView: UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func showComponent(segmentControl: UISegmentedControl)
    {
        if segmentControl.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.resultContainerView.alpha = 1
                self.chartContainerView.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.resultContainerView.alpha = 0
                self.chartContainerView.alpha = 1
            })
        }
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "previewPaper" {
            if let desVC = segue.destinationViewController as? PreviewRootViewController {
                desVC.paper = paper
            }
        } else if segue.identifier == "showOrder" {
            if let desVC = segue.destinationViewController as? ExamResultViewController {
                desVC.paper = paper
            }
        } else if segue.identifier == "showChart" {
            if let desVC = segue.destinationViewController as? ResultChartViewController {
                desVC.paper = paper
            }
        }
    }
    
}
