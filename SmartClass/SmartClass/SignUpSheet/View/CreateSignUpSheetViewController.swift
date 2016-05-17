//
//  CreateSignUpSheetViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/5/13.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class CreateSignUpSheetViewController: UITableViewController
{
    private var records: NSArray?
    var fileURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent("temp.plist")

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
   
        records = NSArray(contentsOfURL: fileURL)
        
        tableView.setEditing(true, animated: true)
        navigationItem.hidesBackButton = true
        
        racBinding()
    }

    func racBinding()
    {
        nameTextField.rac_textSignal().map { (text) -> AnyObject! in
            return (text as! String).length > 0
        } ~> RAC(doneButton, "enabled")

    }
    
    func save()
    {
        let name = nameTextField.text!
        let toFileURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(name)
        
        do {
            let fileManager = NSFileManager.defaultManager()
            try fileManager.removeItemAtURL(fileURL)
            records?.writeToURL(toFileURL, atomically: true)
        } catch let error as NSError {
            print("CreateSignUpSheetViewController save error: \(error.userInfo)")
        }
    }
    
    // MARK: - Action
    
    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return records!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseSignUpStudent", forIndexPath: indexPath)

        let dict = records![indexPath.row] as! NSDictionary
        let name = dict["name"] as! String
        let number = dict["number"] as! String
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = number
        cell.tintColor = ThemeGreenColor

        return cell
    }
 
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle(rawValue: 3)!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let dict = records![indexPath.row] as! NSMutableDictionary
        dict["signed"] = true
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let dict = records![indexPath.row] as! NSMutableDictionary
        dict["signed"] = false
    }
    
}
