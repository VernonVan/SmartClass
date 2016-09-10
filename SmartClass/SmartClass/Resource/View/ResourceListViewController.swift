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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ThemeBlueColor
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
        var number = 0
        
        if segmentedControl.selectedSegmentIndex == 0 {
            number = viewModel!.numberOfPPT()
        } else {
            number = viewModel!.numberOfResource()
        }
        
        tableView.separatorStyle = (number == 0 ? .None : .SingleLine)
        
        return number
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
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyResource")
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("还未添加资源", comment: "" )
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let webUploadURL = appDelegate.webUploaderURL
        var text = ""
        if webUploadURL == "nil" {
            text = NSLocalizedString("打开Wifi网络可上传资源", comment: "" )
        } else{
            text = "访问\(appDelegate.webUploaderURL + "admin/")上传资源"
        }
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0),
                          NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool
    {
        return true
    }
}
