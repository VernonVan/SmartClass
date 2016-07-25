//
//  SignUpSheetListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import DGElasticPullToRefresh

class SignUpSheetListViewController: UITableViewController
{
    var viewModel: SignUpSheetListViewModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        initUI()
        
    }

    func initUI()
    {
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
        viewModel?.reloadData()
        tableView.reloadData()
        tableView.dg_stopLoading()
    }
    
    deinit
    {
        tableView.dg_removePullToRefresh()
    }

    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = viewModel?.numberOfSignUpSheet() ?? 0
        if count == 0 {
            tableView.separatorStyle = .None
        } else {
            tableView.separatorStyle = .SingleLine
        }
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseSignUpSheetCell", forIndexPath: indexPath)

        configureCell(cell, atIndexPath: indexPath)

        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel?.titleForSignUpSheetAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel?.deleteSignUpSheetAtIndexPath(indexPath)
            reloadData()
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
        
        if segue.identifier == "showStudentList" {
            if let desVC = segue.destinationViewController as? StudentListViewController {
                desVC.viewModel = viewModel?.viewModelForStudentList()
            }
        } else if segue.identifier == "showSignUpSheet" {
            if let desVC = segue.destinationViewController as? SignUpSheetViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                let name =  viewModel?.nameAtIndexPath(indexPath)
                desVC.signUpName = name
            }
        } else if segue.identifier == "createSignUpSheet" {
            
        }
    }

}

// MARK: - DZNEmptyDataSet

extension SignUpSheetListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "没有签到记录", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "点击右上角 + 开始签到（学生进行考试也会自动签到）", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    
}
