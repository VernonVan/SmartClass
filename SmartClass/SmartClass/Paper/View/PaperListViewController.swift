//
//  PaperListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import GCDWebServer
import DZNEmptyDataSet

enum PaperListVCSection: Int {
    case issuedPaperSection = 0, editingPaperSection
}

class PaperListViewController: UITableViewController
{
    var viewModel: PaperListViewModel?
    
    @IBOutlet weak var webUploadLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
   
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        webUploadLabel.text = "访问\(appDelegate.webUploaderURL)进行考试"
        
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
        
        if tableView.numberOfSections == 0 {
            tableView.separatorStyle = .None
        } else {
            tableView.separatorStyle = .SingleLine
        }
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReceiveExamResultNotification", object: nil)
    }
    
    // MARK: - Handler
    
    func receiveExamResultHandler(notification: NSNotification)
    {
        print("-----------------------Receive exam result: \(notification.userInfo)----------------------")
        if let resultDict = notification.userInfo {
            viewModel?.modifyStudentListFileWithData(resultDict)
        }
    }
    
    // MARK: - TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return viewModel?.numberOfSections() ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "reusePaperCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)

        return cell
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel?.titleForPaperAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel?.subtitleForPaperAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return viewModel?.titleForHeaderInSection(section)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if viewModel?.isIssuedAtIndexPath(indexPath) == true {
            performSegueWithIdentifier("showExamResult", sender: nil)
        } else {
            performSegueWithIdentifier("editPaper", sender: nil)
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
        } else if segue.identifier == "showExamResult" {
            if let desVC = segue.destinationViewController as? ExamResultViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                desVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        }
    }
    
}

// MARK: - DZNEmptyDataSet
extension PaperListViewController: DZNEmptyDataSetSource
{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "place_logo")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "欢迎来到智慧课堂", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "🏃🏻点击右上角 + 开始创建试卷", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
}
