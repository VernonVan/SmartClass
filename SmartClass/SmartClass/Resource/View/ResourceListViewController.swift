//
//  ResourceListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import QuickLook
import DZNEmptyDataSet
import DGElasticPullToRefresh

class ResourceListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ResourceListViewModel?

    private let reuseIdentifier = "resourceCell"
    private var selectedIndexPath = NSIndexPath()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI()
    {
        navigationItem.rightBarButtonItem = editButtonItem()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(netHex: 0x2196F3)
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    func refresh(refreshControl: UIRefreshControl)
    {
        viewModel?.reloadData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func changeDataSourceAction(segmentedControl: UISegmentedControl)
    {
        tableView.reloadData()
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "displayPPT" {
            if let desVC = segue.destinationViewController as? PPTViewController {
                desVC.pptURL = viewModel?.pptURLAtIndexPath(indexPath!)
            }
        }
    }
}

// MARK: - UITableView 

extension ResourceListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if segmentedControl.selectedSegmentIndex == 0 {
            return viewModel!.numberOfPPT()
        } else {
            return viewModel!.numberOfResource()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        if segmentedControl.selectedSegmentIndex == 0 {
            let ppt = viewModel?.pptAtIndexPath(indexPath)
            cell.configureCellForPPT(ppt)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let resource = viewModel?.resourceAtIndexPath(indexPath)
            cell.configureCellForResource(resource)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if segmentedControl.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("displayPPT", sender: nil)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let previewController = QLPreviewController()
            selectedIndexPath = indexPath
            previewController.dataSource = self
            presentViewController(previewController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            if segmentedControl.selectedSegmentIndex == 0 {
                viewModel?.deletePPTAtIndexPath(indexPath)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            } else if segmentedControl.selectedSegmentIndex == 1 {
                viewModel?.deleteResourceAtIndexPath(indexPath)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.reloadEmptyDataSet()
        }
    }
}

// MARK: - QLPreviewController

extension ResourceListViewController: QLPreviewControllerDataSource
{
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int
    {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem
    {
        return viewModel!.resourceURLAtIndexPath(selectedIndexPath)
    }

    
}

// MARK: - DZNEmptyDataSet

extension ResourceListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        var text = ""
        if segmentedControl.selectedSegmentIndex == 0 {
            text = NSLocalizedString( "还未添加任何幻灯片", comment: "" )
        } else if segmentedControl.selectedSegmentIndex == 1 {
            text = NSLocalizedString( "还未添加任何资源", comment: "" )
        }
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(20.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let webUploadURL = appDelegate.webUploaderURL
        var text = ""
        if webUploadURL == "nil" {
            text = NSLocalizedString( "打开Wifi网络可上传资源", comment: "" )
        } else{
            text = NSLocalizedString( "访问\(appDelegate.webUploaderURL + "admin/")上传资源", comment: "" )
        }
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(12.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool
    {
        return true
    }
}
