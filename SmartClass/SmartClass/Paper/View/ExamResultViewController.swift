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
    var paper: Paper?

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return paper!.results!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseExamResultCell", forIndexPath: indexPath)

        cell.textLabel?.text = (paper?.results!.objectAtIndex(indexPath.row) as! Result).name
        cell.detailTextLabel?.text = "\((paper?.results!.objectAtIndex(indexPath.row) as! Result).score)"
        
        return cell
    }
    
}
