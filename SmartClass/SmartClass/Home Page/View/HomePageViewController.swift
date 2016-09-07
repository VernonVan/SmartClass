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
        
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 245, green: 245, blue: 245)
        
        // 接收学生答题成功的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveExamResult), name: "ReceiveExamResultNotification", object: nil)
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
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReceiveExamResultNotification", object: nil)
    }

    func receiveExamResult(notification: NSNotification)
    {
        if let resultDict = notification.userInfo {
            saveExamResultWithData(resultDict)
        }
    }

    func saveExamResultWithData(resultDict: NSDictionary)
    {
        print("----------\(resultDict)")
        
        guard let paperName = resultDict["paper_title"] as? String, let studentName = resultDict["student_name"] as? String,
            let studentNumber = resultDict["student_number"] as? String, let score = resultDict["score"] as? Int,
            let correctQuestions = resultDict["correctQuestions"] as? [Int], let signDate = resultDict["date"] as? String
            else {
                return
        }
        
        guard let paper = realm.objects(Paper).filter("name = \(paperName)").first else {
            return
        }
        
        try! realm.write {
            let result = Result(value: ["number": studentNumber, "name": studentName, "score": score])
            paper.results.append(result)
        }
        
        // 自动签到
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
    }
    

}
