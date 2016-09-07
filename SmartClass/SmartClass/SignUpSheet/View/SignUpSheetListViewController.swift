//
//  SignUpSheetListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SignUpSheetListViewController: UIViewController
{
    var viewModel: SignUpSheetListViewModel?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        initUI()
    }

    func initUI()
    {
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        viewModel?.reloadData()
        tableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "SignUpSheet" {
            if let desVC = segue.destinationViewController as? SignUpSheetViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                let name =  viewModel?.titleForSignUpSheetAtIndexPath(indexPath)
                desVC.signUpName = name
            }
        }
    }

}

// MARK: - Table View

extension SignUpSheetListViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = viewModel?.numberOfSignUpSheet() ?? 0
        tableView.separatorStyle = (count == 0 ? .None : .SingleLine)
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SignUpSheetListCell", forIndexPath: indexPath)
        cell.textLabel?.text = viewModel?.titleForSignUpSheetAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel?.deleteSignUpSheetAtIndexPath(indexPath)
            tableView.reloadData()
        }
    }
}

// MARK: - DZNEmptyDataSet

extension SignUpSheetListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptySignUpSheet")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("没有签到记录", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0),
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("点击右上角+开始签到（学生进行考试也会自动签到）", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0),
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
}
