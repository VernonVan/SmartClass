//
//  StudentListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

protocol StudentInformationDelegate
{
    func addStudentName(name: String?, number: String?)
    func modifyStudentName(name: String?, number: String?, atIndexPath indexPath: NSIndexPath)
}

class StudentListViewController: UITableViewController, StudentInformationDelegate
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
        cell.textLabel?.text = viewModel!.nameAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel!.numberAtIndexPath(indexPath)
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

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "modifyStudent" {
            if let desVC = segue.destinationViewController as? StudentViewController {
                let indexPath = tableView.indexPathForSelectedRow
                desVC.indexPath = indexPath
                desVC.name = viewModel?.nameAtIndexPath(indexPath!)
                desVC.number = viewModel?.numberAtIndexPath(indexPath!)
                desVC.delegate = self
            }
        } else if segue.identifier == "addStudent" {
            if let desVC = segue.destinationViewController as? StudentViewController {
                desVC.delegate = self
            }
        }
    }
    
    // MARK: - StudentInformationDelegate
    
    func addStudentName(name: String?, number: String?)
    {
        viewModel?.addStudent(name, number:  number)
        tableView.reloadData()
    }
    
    func modifyStudentName(name: String?, number: String?, atIndexPath indexPath: NSIndexPath)
    {
        viewModel?.modifyStudentName(name, number: number, atIndexPath: indexPath)
        tableView.reloadData()
    }
    
}
