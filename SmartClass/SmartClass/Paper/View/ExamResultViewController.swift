//
//  ExamResultViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ExamResultViewController: UITableViewController
{
    private var results: NSArray?
    var paperName: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        
        let studentListURL = ConvenientFileManager.studentListURL
        results = NSArray(contentsOfURL: studentListURL)
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = results?.count ?? 0
        if count == 0 {
            tableView.separatorStyle = .None
        } else {
            tableView.separatorStyle = .SingleLine
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseExamResultCell", forIndexPath: indexPath)
        
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        if let dict = results?[indexPath.row] as? NSDictionary {
            let name = dict["name"] as! String
            cell.textLabel?.text = name
            if let score = dict[paperName!] as? Int {
                cell.detailTextLabel?.text = "\(score)"
                cell.detailTextLabel?.textColor = score > 60 ? UIColor.blueColor() : UIColor.redColor()
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("待考", comment: "")
            }
        }
        
    }
    
}

// MARK: - DZNEmptyDataSetSource
extension ExamResultViewController: DZNEmptyDataSetSource
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "还未添加学生", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "这里应该是跳转到添加学生界面的按钮", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
}
