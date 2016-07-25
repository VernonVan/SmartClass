//
//  PaperListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import GCDWebServer
import Reachability
import DZNEmptyDataSet

enum PaperListVCSection: Int
{
    case issuedPaperSection = 0
    case editingPaperSection
}

class PaperListViewController: UITableViewController
{
    
    var viewModel: PaperListViewModel?
    
    private let reuseIdentifier = "reusePaperCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
  
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = ThemeGreenColor
        
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let webUploaderURL = appDelegate.webUploaderURL
        if webUploaderURL == "nil" {
            view.makeToast(NSLocalizedString("无法发布试卷，请确保Wifi网络可用", comment: ""))
        }
        
        // 接收网络状态的变化的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityChanged), name: kReachabilityChangedNotification, object: nil)
        // 接收学生答题成功的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveExamResultHandler), name: "ReceiveExamResultNotification", object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData()
    {
        do {
            try viewModel?.fetchedResultsController.performFetch()
        } catch {
            print("PaperListViewController fetchedResultsController.performFetch() Error!")
            abort()
        }
        tableView.reloadData()
        
        viewModel?.modifyPaperListFile()
        
        let numberOfSection = viewModel?.numberOfSections()
        tableView.separatorStyle = (numberOfSection == 0) ? .None : .SingleLine
    }
    
    func reachabilityChanged()
    {
        print("网络状态变化")
        view.makeToast("网络状态变化")
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReceiveExamResultNotification", object: nil)
    }
    
    // MARK: - Handler
    
    func receiveExamResultHandler(notification: NSNotification)
    {
        if let resultDict = notification.userInfo {
            viewModel?.modifyStudentListFileWithData(resultDict)
        }
    }
    
    // MARK: - TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return viewModel!.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel?.titleForPaperAtIndexPath(indexPath)
        let issueState = viewModel?.issueStateAtIndexPath(indexPath)
        switch issueState {
        case .Some(.editing):
            cell.textLabel?.textColor = UIColor.blackColor()
        case .Some(.issuing):
            cell.textLabel?.textColor = ThemeGreenColor
        case .Some(.finished):
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        default:
            cell.textLabel?.textColor = ThemeRedColor
        }
        
        cell.detailTextLabel?.text = viewModel?.subtitleForPaperAtIndexPath(indexPath)
        cell.detailTextLabel?.textColor = UIColor.grayColor()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return viewModel?.titleForHeaderInSection(section)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let issueState = viewModel?.issueStateAtIndexPath(indexPath)
        switch issueState {
        case .Some(.editing):
            performSegueWithIdentifier("editPaper", sender: nil)
        case .Some(.issuing):
            performSegueWithIdentifier("showIssuingPaper", sender: nil)
        case .Some(.finished):
            performSegueWithIdentifier("showExamResult", sender: nil)
        default:
            print("didSelectRowAtIndexPath error")
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel!.deletePaperAtIndexPath(indexPath)
        }
        reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if IDIOM == IPAD {
            return 66.0
        }
        return 44.0
    }
    
   
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "createPaper" {
            if let desVC = segue.destinationViewController as? PaperInformationViewController {
                desVC.viewModel = viewModel?.viewModelForNewPaper()
            }
        } else if segue.identifier == "editPaper" {
            if let examViewController = segue.destinationViewController as? PaperInformationViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                examViewController.viewModel = viewModel?.viewModelForExistPaper(indexPath)
            }
        } else if segue.identifier == "showIssuingPaper" {
            if let issuingPaperVC = segue.destinationViewController as? IssuingPaperViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                issuingPaperVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        } else if segue.identifier == "showExamResult" {
            if let desVC = segue.destinationViewController as? ExamResultViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                desVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        } else if segue.identifier == "showQRCode" {
            if let desVC = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? QRCodeViewController {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                desVC.url = appDelegate.webUploaderURL
            }
        }
    }

}

// MARK: - DZNEmptyDataSet

extension PaperListViewController: DZNEmptyDataSetSource
{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "logo")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "🏃🏻点击右上角 + 开始创建试卷", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(18.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
