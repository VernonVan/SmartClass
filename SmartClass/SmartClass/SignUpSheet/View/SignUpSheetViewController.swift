//
//  SignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/3.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class SignUpSheetViewController: UITableViewController
{
    private var records: NSArray?
    var fileURL: NSURL?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        records = NSArray(contentsOfURL: fileURL!)
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return records!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseSignUpCell", forIndexPath: indexPath)

        configureCellAtIndexPath(cell, atIndexPath: indexPath)

        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        let dict = records![indexPath.row] as! NSDictionary
        let name = dict["name"] as! String
        cell.textLabel?.text = name
        if let signed = dict["signed"] as? Bool {
            cell.accessoryType = signed ? .Checkmark : .None
        } else {
            cell.accessoryType = .None
        }
    }

}
