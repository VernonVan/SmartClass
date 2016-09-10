//
//  PaperListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift
import GCDWebServer
import Reachability
import DZNEmptyDataSet

enum PaperListVCSection: Int
{
    case EditingPaperSection = 0
    case IssuingPaperSection = 1
    case FinishedPaperSection = 2
}

class PaperListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PaperListViewModel?
  
    private let disposeBag = DisposeBag()
    private let reuseIdentifier = "reusePaperCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
        
        // 接收网络状态的变化的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityChanged), name: kReachabilityChangedNotification, object: nil)
    }
    
    func initUI()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let webUploaderURL = appDelegate.webUploaderURL
        if webUploaderURL == "nil" {
            view.makeToast(NSLocalizedString("无法发布试卷，请确保Wifi网络可用", comment: ""))
        }
    }

    @IBAction func paperTypeChangeAction(segmentedControl: UISegmentedControl)
    {
        viewModel?.paperType = PaperType(rawValue: segmentedControl.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    func reachabilityChanged()
    {
        view.makeToast(NSLocalizedString("网络状态变化", comment: ""))
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
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
            if let desVC = segue.destinationViewController as? ResultContainerViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                desVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        }
    }
}

// MARK: - TableView

extension PaperListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let number = viewModel!.numberOfPapers()
        tableView.separatorStyle = (number == 0 ? .None : .SingleLine)
        return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let paper = viewModel?.paperAtIndexPath(indexPath)
        configureCell(cell, withPaper: paper)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, withPaper paper: Paper?)
    {
        cell.textLabel?.text = paper?.name
        cell.detailTextLabel?.text = paper?.blurb
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let paper = viewModel?.paperAtIndexPath(indexPath)
        switch PaperIssueState(rawValue: paper!.state)! {
        case .editing:
            performSegueWithIdentifier("editPaper", sender: nil)
        case .issuing:
            performSegueWithIdentifier("showIssuingPaper", sender: nil)
        case .finished:
            performSegueWithIdentifier("showExamResult", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, canEditowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel!.deletePaperAtIndexPath(indexPath)
        }
        tableView.reloadData()
    }
}

// MARK: - DZNEmptyDataSet

extension PaperListViewController: DZNEmptyDataSetSource
{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyPaper")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("点击右上角+开始创建试卷", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
