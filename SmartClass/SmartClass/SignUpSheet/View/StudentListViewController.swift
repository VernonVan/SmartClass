//
//  StudentListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast

protocol StudentInformationDelegate
{
    func addStudentName(name: String?, number: String?, college: String?, school: String?)
    func modifyStudentName(name: String?, number: String?, college: String?, school: String?, atIndexPath indexPath: NSIndexPath)
}

class StudentListViewController: UITableViewController
{
    var viewModel: StudentListViewModel?
    
    private let reuseStudentCell = "reuseStudentCell"
    private let addStudentCell = "addStudentCell"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.editing = true
        tableView.allowsSelectionDuringEditing = true
    }

    override func willMoveToParentViewController(parent: UIViewController?)
    {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            viewModel!.save()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfStudents() + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var identifier = ""
        if viewModel?.numberOfStudents() == indexPath.row {
            identifier = addStudentCell
        } else {
            identifier = reuseStudentCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if indexPath.row < viewModel?.numberOfStudents() {
            configureCellAtIndexPath(cell, atIndexPath: indexPath)
        }
     
        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = "\(viewModel!.numberAtIndexPath(indexPath)!) - \(viewModel!.nameAtIndexPath(indexPath)!)"
        let college = viewModel?.collegeAtIndexPath(indexPath) ?? ""
        let school = viewModel?.schoolAtIndexPath(indexPath) ?? ""
        let detailText = "\(college)(\(school))"
        cell.detailTextLabel?.text = college.length == 0 ? nil : detailText
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        if indexPath.row == viewModel?.numberOfStudents() {
            return .Insert
        }
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Insert {
            performSegueWithIdentifier("addStudent", sender: nil)
        } else if editingStyle == .Delete {
            viewModel!.deleteStudentAtIndexPath(indexPath)
        }
        
        tableView.reloadData()
    }

    // MARK: - Action
    
    @IBAction func uploadStudentListAction(sender: UIBarButtonItem)
    {
        showFileNameAlertView()
    }
    
    func showFileNameAlertView()
    {
        let alertController = UIAlertController(title: NSLocalizedString("输入文件名", comment: "") , message: NSLocalizedString("输入学生名单的文件名（请把文件放在根目录下）", comment: ""), preferredStyle: .Alert)
        
        let commitAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default) { (_) in
            let textField = alertController.textFields![0] as UITextField
            self.uploadStudentFromFile(textField.text!)
        }
        commitAction.enabled = false
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .Cancel, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString("文件名", comment: "")
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                commitAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(commitAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func uploadStudentFromFile(name: String)
    {
        if viewModel?.uploadStudentFromFile(name) == false {
            view.makeToast(NSLocalizedString("导入学生列表失败！", comment: ""), duration: 1.5, position: CSToastPositionCenter)
        } else {
            tableView.reloadData()
            view.makeToast(NSLocalizedString("导入成功！", comment: ""), duration: 1.5, position: CSToastPositionCenter)
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "modifyStudent" {
            if let desVC = segue.destinationViewController as? StudentViewController {
                let indexPath = tableView.indexPathForSelectedRow
                desVC.indexPath = indexPath
                desVC.name = viewModel?.nameAtIndexPath(indexPath!)
                desVC.number = viewModel?.numberAtIndexPath(indexPath!)
                desVC.college = viewModel?.collegeAtIndexPath(indexPath!)
                desVC.school = viewModel?.schoolAtIndexPath(indexPath!)
                desVC.delegate = self
            }
        } else if segue.identifier == "addStudent" {
            if let desVC = segue.destinationViewController as? StudentViewController {
                desVC.delegate = self
            }
        }
    }
    
}

// MARK: - StudentInformationDelegate
extension StudentListViewController: StudentInformationDelegate
{
    func addStudentName(name: String?, number: String?, college: String?, school: String?)
    {
        viewModel?.addStudent(name, number:  number, college: college, school: school)
        tableView.reloadData()
    }
    
    func modifyStudentName(name: String?, number: String?, college: String?, school: String?, atIndexPath indexPath: NSIndexPath)
    {
        viewModel?.modifyStudentName(name, number: number, college: college, school: school, atIndexPath: indexPath)
        tableView.reloadData()
    }
}
