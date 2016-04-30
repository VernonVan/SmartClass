//
//  TeacherMainInterfaceTableViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

private enum MasterViewControllerSection: Int {
    case PaperSection, pptSection, ResourceSection, SignSection
}

class MasterViewController: UITableViewController, DZNEmptyDataSetSource
{
    // MARK: - constant
    private let reuseBeforeExamCellIdentifier = "beforeCell"
    private let reuseAfterExamCellIdentifier = "afterCell"
    private let pptCellIdentifier = "pptCell"
    private let undefineCellIdentifier = "resourceCell"
    private let signUpCellIdentifier = "signUpCell"
    
    // MARK: - variable
    var viewModel: MasterViewModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        
        viewModel?.updatedContentSignal.subscribeNext({ [unowned self] (x) in
            self.tableView.reloadData()
        })
        
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.whiteColor()
        refreshControl!.tintColor = ThemeGreenColor
        refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
    }
    
    func reloadData()
    {
        tableView.reloadData()

        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setEditing(false, animated: false)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return viewModel!.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return viewModel!.numberOfPapers()
        } else if section == 1 {
            return viewModel!.numberOfPPTs()
        } else if section == 2 {
            return viewModel!.numberOfResources()
        } else if section == 3 {
            return viewModel!.numberOfSignUpSheet()
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var reuseIdentifier: String = ""
        if indexPath.section == 0 {
            reuseIdentifier = (viewModel?.isIssuedAtIndexPath(indexPath) == true) ? reuseAfterExamCellIdentifier : reuseBeforeExamCellIdentifier
        } else if indexPath.section == 1 {
                reuseIdentifier = pptCellIdentifier
        } else if indexPath.section == 2{
            reuseIdentifier = undefineCellIdentifier
        } else if indexPath.section == 3 {
            reuseIdentifier = signUpCellIdentifier
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            configurePaperCell(cell, atIndexPath: indexPath)
        }  else if indexPath.section == 1 {
            configurePPTCell(cell, atIndexPath: indexPath)
        } else if indexPath.section == 2 {
            configureResourceCell(cell, atIndexPath: indexPath)
        } else if indexPath.section == 3 {
            configureSignUpSheetCell(cell, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    func configurePaperCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel!.titleForPaperAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel!.subtitleForPaperAtIndexPath(indexPath)
    }
    
    func configurePPTCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel!.titleForPPTAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel!.subtitleForPPTAtIndexPath(indexPath)
    }
    
    func configureResourceCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel!.titleForResourceAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel!.subtitleForResourceAtIndexPath(indexPath)
    }
    
    func configureSignUpSheetCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = viewModel!.titleForSignUpSheetAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            if indexPath.section == 0 {
                viewModel!.deletePaperAtIndexPath(indexPath)
            } else if indexPath.section == 1 {
                viewModel!.deletePPTAtIndexPath(indexPath)
            } else if indexPath.section == 2 {
                viewModel!.deleteResourceAtIndexPath(indexPath)
            } else if indexPath.section == 3 {
                viewModel!.deleteSignUpSheetAtIndexPath(indexPath)
            }
            
            tableView.reloadData()
           // tableView.reloadSections(NSIndexSet(index: indexPath.section) ,withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0 {
            return NSLocalizedString("试卷", comment: "")
        }  else if section == 1 {
            return NSLocalizedString("PPT", comment: "")
        } else if section == 2 {
            return NSLocalizedString("资源", comment: "")
        } else if section == 3 {
            return NSLocalizedString("签到表", comment: "")
        }
        return nil
    }
    
    // MARK: - table view delegate 

    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "createExam" {
            if let desVC = segue.destinationViewController as? PaperInformationViewController {
                desVC.viewModel = viewModel?.viewModelForNewPaper()
            }
        } else if segue.identifier == "editExam" {
            if let examViewController = segue.destinationViewController as? PaperInformationViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                examViewController.viewModel = viewModel?.viewModelForExistPaper(indexPath)
            }
        } else if segue.identifier == "undefineResource" {
            if let desVC = segue.destinationViewController as? UndefineResourceViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                desVC.resourceURL = viewModel?.resourceURLAtIndexPath(indexPath)
            }
        } else if segue.identifier == "displayPPT" {
            if let desVC = segue.destinationViewController as? PPTViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                desVC.pptURL = viewModel?.pptURLAtIndexPath(indexPath)
            }
        } else if segue.identifier == "showStudentList" {
            if let desVC = segue.destinationViewController as? StudentListViewController {
                desVC.viewModel = viewModel?.viewModelForStudentList()
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

