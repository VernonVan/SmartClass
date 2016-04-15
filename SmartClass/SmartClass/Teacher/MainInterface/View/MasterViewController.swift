//
//  TeacherMainInterfaceTableViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MasterViewController: UITableViewController, DZNEmptyDataSetSource
{
    // MARK: - constant
    private let reuseBeforeExamCell = "beforeCell"
    private let reuseAfterExamCell = "afterCell"
    
    // MARK: - variable
    var viewModel: MasterViewModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        navigationItem.leftBarButtonItem = self.editButtonItem()
        
        viewModel?.updatedContentSignal.subscribeNext({ [unowned self] (x) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return viewModel!.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let reuseIdentifier = (viewModel?.isFinishedAtIndexPath(indexPath) == true) ? reuseAfterExamCell : reuseBeforeExamCell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel!.titleAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel!.subtitleAtIndexPath(indexPath)
    }
    
    // MARK: - table view delegate 
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            viewModel!.deleteItemAtIndexPath(indexPath)
        }
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "createExam" {
            if let examViewController = segue.destinationViewController as? ExamViewController {
                examViewController.viewModel = viewModel?.viewModelForNewExam()
            }
        } else if segue.identifier == "editExam" {
            if let examViewController = segue.destinationViewController as? ExamViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                examViewController.viewModel = viewModel?.viewModelForExistExam(indexPath)
            }
        }
    }
  
    // MARK: - DZNEmptyDataSet data source
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "place_logo")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "欢迎来到智慧课堂", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "🏃🏻点击右上角 + 开始创建试卷", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0) ,
            NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
}

