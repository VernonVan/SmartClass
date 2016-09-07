//
//  SignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/3.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class SignUpSheetViewController: UITableViewController
{
    var signUpName: String?
    
    private var students: Results<Student>!
    private var signedNames: NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = signUpName
        
        let realm = try! Realm()
        students = realm.objects(Student).sorted("number")
        
        let url = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpName!)
        signedNames = NSArray(contentsOfURL: url)
        
        tableView.emptyDataSetSource = self
        tableView.registerNib(UINib(nibName: "SignUpSheetCell", bundle: nil), forCellReuseIdentifier: "SignUpSheetCell")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SignUpSheetCell", forIndexPath: indexPath) as! SignUpSheetCell
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCellAtIndexPath(cell: SignUpSheetCell, atIndexPath indexPath : NSIndexPath)
    {
        cell.nameLabel.text = "\(students[indexPath.row].name) - \(students[indexPath.row].number)"
        cell.majorLabel.text = "\(students[indexPath.row].major!)(\(students[indexPath.row].school!))"
        
        if signedNames.containsObject(students[indexPath.row].name) {
            cell.selectCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0
    }
}

// MARK: - DZNEmptyDataSet

extension SignUpSheetViewController: DZNEmptyDataSetSource
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("请先添加学生", comment: "")
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
                          NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }

}


