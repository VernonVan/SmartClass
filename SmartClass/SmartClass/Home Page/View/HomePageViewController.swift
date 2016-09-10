//
//  HomePageViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/25.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class HomePageViewController: UIViewController
{
    
    @IBOutlet weak var paperCardView: CardView!
    @IBOutlet weak var resourceCardView: CardView!
    @IBOutlet weak var signUpSheetCardView: CardView!

    private let realm = try! Realm()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshCardViewBadgeNumber()
    }
    
    func refreshCardViewBadgeNumber()
    {
        let paperCount = realm.objects(Paper).count
        paperCardView.number = paperCount
        
        let signUpSheetPath = ConvenientFileManager.signUpSheetURL.path!
        let pptPath = ConvenientFileManager.pptURL.path!
        let resourcePath = ConvenientFileManager.resourceURL.path!
        
        do {
            let pptCount = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(pptPath).count
            let otherCount = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(resourcePath).count
            resourceCardView.number = pptCount + otherCount
            signUpSheetCardView.number = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(signUpSheetPath).count
        } catch let error as NSError {
            print("HomePageViewController refreshCardViewBadgeNumber error: \(error.localizedDescription)")
        }
        
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
                let paperListViewModel = PaperListViewModel()
                desVC.viewModel = paperListViewModel
            }
        } else if segue.identifier == "showQRCode" {
            if let desVC = segue.destinationViewController as? QRCodeViewController {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                desVC.url = appDelegate.webUploaderURL
            }
        } else if segue.identifier == "StudentList" {
            if let desVC = segue.destinationViewController as? StudentListViewController {
                desVC.viewModel = StudentListViewModel()
            }
        } else if segue.identifier == "SignUpSheetList" {
            if let desVC = segue.destinationViewController as? SignUpSheetListViewController {
                desVC.viewModel = SignUpSheetListViewModel()
            }
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    

}
