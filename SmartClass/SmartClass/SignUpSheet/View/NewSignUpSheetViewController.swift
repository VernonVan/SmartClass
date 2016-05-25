//
//  NewSignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class NewSignUpSheetViewController: UITableViewController
{
    private var records: NSArray?
    var signUpName = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
 
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let fileURL = ConvenientFileManager.studentListURL
        records = NSArray(contentsOfURL: fileURL)
        
        tableView.setEditing(true, animated: false)
        
        racBinding()
    }
    
    func racBinding()
    {
        nameTextField.rac_textSignal().map { (text) -> AnyObject! in
            return (text as! String).length > 0
        } ~> RAC(doneButton, "enabled")
        
        nameTextField.rac_textSignal().subscribeNext { (text) in
            self.signUpName = text as! String
        }
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return records!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseSignUpStudent", forIndexPath: indexPath)
        
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        cell.tintColor = ThemeGreenColor
        
        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        if let dict = records?[indexPath.row] as? NSDictionary {
            let name = dict["name"] as! String
            let number = dict["number"] as! String
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = number
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return unsafeBitCast(3, UITableViewCellEditingStyle.self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if IDIOM == IPAD {
            return 54.0
        }
        return 44.0
    }
    
    // MARK: - Action
    
    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in selectedIndexPaths {
                let studentDict = records?[indexPath.row] as! NSMutableDictionary
                studentDict[signUpName] = true
            }
            let fileURL = ConvenientFileManager.studentListURL
            records?.writeToURL(fileURL, atomically: true)
            
            addSignUpSheet(signUpName)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addSignUpSheet(name: String)
    {
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
