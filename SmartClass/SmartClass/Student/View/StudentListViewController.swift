//
//  StudentListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast
import DZNEmptyDataSet

protocol StudentInformationDelegate
{
    func addStudent(student: Student)
    func modifyStudentAtIndexPath(indexPath: NSIndexPath, newStudent student: Student)
}

class StudentListViewController: UIViewController
{
    var viewModel: StudentListViewModel?
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self

        addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4.0)
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "modifyStudent" {
            if let desVC = segue.destinationViewController as? StudentInformationViewController {
                let indexPath = tableView.indexPathForSelectedRow
                desVC.indexPath = indexPath
                desVC.student = viewModel?.studentAtIndexPath(indexPath!)
                desVC.delegate = self
            }
        } else if segue.identifier == "addStudent" {
            if let desVC = segue.destinationViewController as? StudentInformationViewController {
                desVC.delegate = self
            }
        }
    }
    
}

// MARK: - Table view

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfStudents()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! StudentCell
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCellAtIndexPath(cell: StudentCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.nameLabel?.text = "\(viewModel!.nameAtIndexPath(indexPath)) - \(viewModel!.numberAtIndexPath(indexPath))"
        cell.majorLabel?.text = "\(viewModel!.majorAtIndexPath(indexPath))(\(viewModel!.schoolAtIndexPath(indexPath)))"
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel?.deleteStudentAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return StudentCell.cellHeight
    }
}

// MARK: - StudentInformationDelegate

extension StudentListViewController: StudentInformationDelegate
{
    func addStudent(student: Student)
    {
        viewModel?.addStudent(student)
        tableView.reloadData()
    }
    
    func modifyStudentAtIndexPath(indexPath: NSIndexPath, newStudent student: Student)
    {
        viewModel?.modifyStudentAtIndexPath(indexPath, newStudent: student)
        tableView.reloadData()
    }
}

// MARK: - DZNEmptyDataSet

extension StudentListViewController: DZNEmptyDataSetSource
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("尚未添加学生", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(18.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
}
