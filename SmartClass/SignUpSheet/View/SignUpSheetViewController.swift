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
    
    fileprivate var students: Results<Student>!
    fileprivate var signedNames: NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = signUpName
        
        let realm = try! Realm()
        students = realm.objects(Student.self).sorted(byProperty: "number")
        
        let url = ConvenientFileManager.signUpSheetURL.appendingPathComponent(signUpName!)
        signedNames = NSArray(contentsOf: url)
        
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SignUpSheetCell", bundle: nil), forCellReuseIdentifier: "SignUpSheetCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpSheetCell", for: indexPath) as! SignUpSheetCell
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCellAtIndexPath(_ cell: SignUpSheetCell, atIndexPath indexPath : IndexPath)
    {
        cell.nameLabel.text = "\(students[(indexPath as NSIndexPath).row].name) - \(students[(indexPath as NSIndexPath).row].number)"
        cell.majorLabel.text = "\(students[(indexPath as NSIndexPath).row].major!)(\(students[(indexPath as NSIndexPath).row].school!))"
        
        if signedNames.contains(students[(indexPath as NSIndexPath).row].name) {
            cell.selectCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
}

// MARK: - DZNEmptyDataSet

extension SignUpSheetViewController: DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("请先添加学生", comment: "")
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22.0),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }

}


