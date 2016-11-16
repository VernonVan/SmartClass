//
//  NewSignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class NewSignUpSheetViewController: UITableViewController
{
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    fileprivate var students: Results<Student>!
    fileprivate var signedNames = NSMutableArray()
 
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let realm = try! Realm()
        students = realm.objects(Student.self).sorted(byProperty: "number")
        
        tableView.emptyDataSetSource = self
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SignUpSheetCell", bundle: nil), forCellReuseIdentifier: "SignUpSheetCell")
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.separatorStyle = students.count == 0 ? .none : .singleLine
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
        cell.signImageView.image = UIImage(named: "unsignedCell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! SignUpSheetCell
        cell.selectCell()
        
        let student = students[(indexPath as NSIndexPath).row]
        signedNames.add(student.name)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! SignUpSheetCell
        cell.deselectCell()
        
        let student = students[(indexPath as NSIndexPath).row]
        signedNames.remove(student.name)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    // MARK: - Action
    
    @IBAction func doneAction(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("请输入签到表名称", comment: ""), preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default) { (_) in
            let textField = alert.textFields![0] as UITextField
            self.addSignUpSheet(textField.text!)
            _ = self.navigationController?.popViewController(animated: true)
        }
        doneAction.isEnabled = false
        alert.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("签到表名称", comment: "")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                doneAction.isEnabled = textField.text != ""
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func addSignUpSheet(_ name: String)
    {
        let url = ConvenientFileManager.signUpSheetURL.appendingPathComponent(name)
        signedNames.write(to: url, atomically: true)
        
        var signUpSheetArray: NSMutableArray
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "signUpSheet") == nil {
            signUpSheetArray = NSMutableArray()
        } else {
            signUpSheetArray = NSMutableArray(array: userDefaults.object(forKey: "signUpSheet") as! Array)
        }
        
        if !signUpSheetArray.contains(name) {
            signUpSheetArray.add(name)
        }
        userDefaults.setValue(signUpSheetArray, forKey: "signUpSheet")
        userDefaults.synchronize()
    }
}

// MARK: - DZNEmptyDataSet

extension NewSignUpSheetViewController: DZNEmptyDataSetSource
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyStudent")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("请先添加学生", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
