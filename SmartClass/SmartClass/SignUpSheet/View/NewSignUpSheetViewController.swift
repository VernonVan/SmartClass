//
//  NewSignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class NewSignUpSheetViewController: UITableViewController
{
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var students: Results<Student>!
    private var signedNames = NSMutableArray()
 
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let realm = try! Realm()
        students = realm.objects(Student).sorted("number")
        
        tableView.allowsMultipleSelection = true
        tableView.registerNib(UINib(nibName: "SignUpSheetCell", bundle: nil), forCellReuseIdentifier: "SignUpSheetCell")
    }
    
    // MARK: - TableView
    
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
        cell.signImageView.image = UIImage(named: "unsignedCell")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SignUpSheetCell
        cell.selectCell()
        
        let student = students[indexPath.row]
        signedNames.addObject(student.name)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SignUpSheetCell
        cell.deselectCell()
        
        let student = students[indexPath.row]
        signedNames.removeObject(student.name)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0
    }
    
    // MARK: - Action
    
    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("请输入签到表名称", comment: ""), preferredStyle: .Alert)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default) { (_) in
            let textField = alert.textFields![0] as UITextField
            self.addSignUpSheet(textField.text!)
            self.navigationController?.popViewControllerAnimated(true)
        }
        doneAction.enabled = false
        alert.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .Default, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString("签到表名称", comment: "")
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                doneAction.enabled = textField.text != ""
            }
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addSignUpSheet(name: String)
    {
        let url = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(name)
        signedNames.writeToURL(url, atomically: true)
        
        var signUpSheetArray: NSMutableArray
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("signUpSheet") == nil {
            signUpSheetArray = NSMutableArray()
        } else {
            signUpSheetArray = NSMutableArray(array: userDefaults.objectForKey("signUpSheet") as! Array)
        }
        
        if !signUpSheetArray.containsObject(name) {
            signUpSheetArray.addObject(name)
        }
        userDefaults.setValue(signUpSheetArray, forKey: "signUpSheet")
        userDefaults.synchronize()
    }
    

}
