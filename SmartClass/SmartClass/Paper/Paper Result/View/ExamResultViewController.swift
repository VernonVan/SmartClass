//
//  ExamResultViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class ExamResultViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    private var students: Results<Student>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let realm = try! Realm()
        students = realm.objects(Student).sorted("number")
        
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Table view

extension ExamResultViewController: UITableViewDataSource
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ResultCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.starImageView.hidden = true
        cell.orderLabel.text = "\(indexPath.row+1)"
        cell.nameLabel.text = students[indexPath.row].name
        cell.scoreLabel.text = "缺考"
        cell.scoreLabel.textColor = UIColor.lightGrayColor()
        
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.whiteColor() : UIColor(netHex: 0xf5f5f5)
    }
    
}

// MARK: - DZNEmptyDataSetSource

extension ExamResultViewController: DZNEmptyDataSetSource
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("请先添加学生", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
