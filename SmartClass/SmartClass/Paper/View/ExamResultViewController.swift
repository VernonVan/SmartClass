//
//  ExamResultViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ExamResultViewController: UITableViewController
{
    private var results: NSArray?
    var fileURL: NSURL?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        results = NSArray(contentsOfURL: fileURL!)
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseExamResultCell", forIndexPath: indexPath)
        
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        let dict = results![indexPath.row] as! NSDictionary
        let name = dict["name"] as! String
        cell.textLabel?.text = name
        if let score = dict["score"] as? Int {
            cell.detailTextLabel?.text = "\(score)"
            cell.detailTextLabel?.textColor = score > 60 ? UIColor.blueColor() : UIColor.redColor()
        } else {
            cell.detailTextLabel?.text = NSLocalizedString("待考", comment: "")
        }
    }
    
}
