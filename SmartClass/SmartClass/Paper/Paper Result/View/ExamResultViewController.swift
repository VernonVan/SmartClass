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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


struct ResultItem
{
    var studentName: String
    var score: Int?
}

class ExamResultViewController: UIViewController
{
    var paper: Paper?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var items = [ResultItem]()
    
    fileprivate var students: Results<Student>!
    
    fileprivate let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        students = realm.objects(Student.self).sorted(byProperty: "number")
        configureResultItems()
        
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
    }
    
    func configureResultItems()
    {
        let results = paper!.results.sorted(byProperty: "score", ascending: false)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: ResultCell, atIndexPath indexPath: IndexPath)
    {
        let item = items[(indexPath as NSIndexPath).row]
        if (indexPath as NSIndexPath).row < 3 && item.score != nil {
            cell.starImageView.isHidden = false
            cell.orderLabel.isHidden = true
        } else {
            cell.starImageView.isHidden = true
            cell.orderLabel.text = "\((indexPath as NSIndexPath).row + 1)"
        }

        cell.nameLabel.text = item.studentName
        cell.scoreLabel.text = (item.score != nil ? "\(item.score!)" : NSLocalizedString("缺考", comment: ""))
        cell.scoreLabel.textColor = item.score != nil ? (item.score > 60 ? UIColor.red : ThemeBlueColor) : UIColor.lightGray
        
        cell.backgroundColor = ((indexPath as NSIndexPath).row % 2 == 0) ? UIColor.white : UIColor(netHex: 0xf5f5f5)
    }
    
}

// MARK: - DZNEmptyDataSetSource

extension ExamResultViewController: DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("请先添加学生", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
