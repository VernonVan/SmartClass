//
//  SignUpSheetListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SignUpSheetListViewController: UITableViewController
{
    
    var viewModel: SignUpSheetListViewModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.emptyDataSetSource = self
        
        initSpinner()
    }
    
    func initSpinner()
    {
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.whiteColor()
        refreshControl!.tintColor = ThemeGreenColor
        refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData()
    {
        viewModel?.reloadData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
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
                let signUpSheetName = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
                let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName!)
                desVC.fileURL = signUpSheetURL
            }
        } else if segue.identifier == "createSignUpSheet" {
            viewModel?.createTempSignUpSheet()
        }
    }

}

// MARK: - DZNEmptyDataSet
extension SignUpSheetListViewController: DZNEmptyDataSetSource
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
}
