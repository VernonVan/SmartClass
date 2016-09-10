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

struct ResultItem
{
    var studentName: String
    var score: Int?
}

class ExamResultViewController: UIViewController
{
    var paper: Paper?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var items = [ResultItem]()
    
    private var students: Results<Student>!
    
    private let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        students = realm.objects(Student).sorted("number")
        
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        
        configureResultItems()
    }
    
    func configureResultItems()
    {
        let results = paper!.results.sorted("score", ascending: false)
        for result in results {
            let item = ResultItem(studentName: result.name!, score: result.score)
            items.append(item)
        }
        
        for student in students {
            if results.filter("name == '\(student.name)'").first == nil {
                let item = ResultItem(studentName: student.name, score: nil)
                items.append(item)
            }
        }
    }
}

// MARK: - Table view

extension ExamResultViewController: UITableViewDataSource
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ResultCell, atIndexPath indexPath: NSIndexPath)
    {
        let item = items[indexPath.row]
        if indexPath.row < 3 && item.score != nil {
            cell.starImageView.hidden = false
            cell.orderLabel.hidden = true
        } else {
            cell.starImageView.hidden = true
            cell.orderLabel.text = "\(indexPath.row + 1)"
        }

        cell.nameLabel.text = item.studentName
        cell.scoreLabel.text = (item.score != nil ? "\(item.score!)" : NSLocalizedString("缺考", comment: ""))
        cell.scoreLabel.textColor = item.score != nil ? (item.score > 60 ? UIColor.redColor() : ThemeBlueColor) : UIColor.lightGrayColor()
        
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
