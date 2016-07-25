//
//  ResourceListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import QuickLook
import Reachability
import DZNEmptyDataSet
import DGElasticPullToRefresh

enum ResourceListVCSection: Int {
    case PPTSection, ResourceSection
}

class ResourceListViewController: UITableViewController
{
    
    lazy var viewModel: ResourceListViewModel = {
        return ResourceListViewModel()
    }()
    
    var reach: Reachability?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(reachabilityChanged),
                                                         name: kReachabilityChangedNotification,
                                                         object: nil)
    }
    
    func initUI()
    {
        navigationItem.rightBarButtonItem = editButtonItem()
    
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = ThemeGreenColor
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.separatorStyle = .None
        
        // pull-to-refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.reloadData()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(ThemeGreenColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func reloadData()
    {
        viewModel.reloadData()
        tableView.reloadData()
        tableView.dg_stopLoading()
    }
    
    // 网络状态变化
    func reachabilityChanged()
    {
        tableView.reloadEmptyDataSet()
    }
    
    deinit
    {
        tableView.dg_removePullToRefresh()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
    }

    // MARK: - TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        var reuseIdentifier: String
        let section = ResourceListVCSection(rawValue: indexPath.section)!
        
        switch section {
        case .PPTSection:
            reuseIdentifier = "reusePPTCell"
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
            configurePPTCell(cell, atIndexPath: indexPath)
        case .ResourceSection:
            reuseIdentifier = "reuseResourceCell"
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
            configureResourceCell(cell, atIndexPath: indexPath)
        }
        
        return cell
    }
 
    func configurePPTCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel.titleForPPTAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel.subtitleForPPTAtIndexPath(indexPath)
    }
    
    func configureResourceCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel.titleForResourceAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel.subtitleForResourceAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return viewModel.titleForHeaderInSection(section)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            let section = ResourceListVCSection(rawValue: indexPath.section)!
            switch section {
            case .PPTSection:
                viewModel.deletePPTAtIndexPath(indexPath)
            case .ResourceSection:
                viewModel.deleteResourceAtIndexPath(indexPath)
            }
            
            reloadData()
        }
    }
    
    var selectedIndexPath: NSIndexPath?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if ResourceListVCSection(rawValue: indexPath.section) == .ResourceSection {
            selectedIndexPath = indexPath
            let previewController = QLPreviewController()
            previewController.dataSource = self
            presentViewController(previewController, animated: true, completion: nil)
        }
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
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "displayPPT" {
            if let desVC = segue.destinationViewController as? PPTViewController {
                desVC.pptURL = viewModel.pptURLAtIndexPath(indexPath!)
            }
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
        return viewModel.resourceURLAtIndexPath(selectedIndexPath!)
    }

    
}

// MARK: - DZNEmptyDataSet

extension ResourceListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "还未添加任何资源", comment: "" )
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
