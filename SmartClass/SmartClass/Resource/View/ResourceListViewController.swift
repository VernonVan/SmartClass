//
//  ResourceListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import QuickLook
import SafariServices
import DZNEmptyDataSet

enum ResourceListVCSection: Int {
    case PPTSection, ResourceSection
}

class ResourceListViewController: UITableViewController
{
    
    lazy var viewModel: ResourceListViewModel = {
        return ResourceListViewModel()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        tableView.emptyDataSetSource = self
        
        tableView.separatorStyle = .None
        
        initSpinner()
    }

    func initSpinner()
    {
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.whiteColor()
        refreshControl!.tintColor = ThemeGreenColor
        refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
    }
    
    func reloadData()
    {
        viewModel.reloadData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        reloadData()
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
extension ResourceListViewController: DZNEmptyDataSetSource
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
        let webUploadURL = NSURL(string: appDelegate.webUploaderURL + "admin/")
        let text = NSLocalizedString( "访问\(webUploadURL!)上传资源", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(12.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
