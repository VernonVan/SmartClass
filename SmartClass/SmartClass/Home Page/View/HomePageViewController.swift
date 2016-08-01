//
//  HomePageViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/25.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "showResourceList" {
            if let desVC = segue.destinationViewController as? ResourceListViewController {
                let viewModel = ResourceListViewModel()
                desVC.viewModel = viewModel
            }
        } else if segue.identifier == "showPaperList" {
            if let desVC = segue.destinationViewController as? PaperListViewController {
                let paperListViewModel = PaperListViewModel(model: CoreDataStack.defaultStack.managedObjectContext)
                desVC.viewModel = paperListViewModel
            }
        } else if segue.identifier == "showQRCode" {
            if let desVC = segue.destinationViewController as? QRCodeViewController {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                desVC.url = appDelegate.webUploaderURL
            }
        }
    }
    

}
