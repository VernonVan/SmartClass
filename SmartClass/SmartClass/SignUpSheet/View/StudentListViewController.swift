//
//  StudentListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class StudentListViewController: UITableViewController, DZNEmptyDataSetSource
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    // MARK: - Action
    
//    uploadStudent
    
    // MARK: - DZNEmptyDataSet data source
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyUser")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "还没有添加学生", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
}
