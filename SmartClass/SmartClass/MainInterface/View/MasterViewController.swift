//
//  TeacherMainInterfaceTableViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

enum MasterViewControllerSection: Int {
    case PaperSection = 0, PPTSection = 1, ResourceSection = 2, SignSection = 3
}

class MasterViewController: UITableViewController, DZNEmptyDataSetSource
{
    private let reuseBeforeExamCellIdentifier = "beforeCell"
    private let reuseAfterExamCellIdentifier = "afterCell"
    private let pptCellIdentifier = "pptCell"
    private let undefineCellIdentifier = "resourceCell"
    private let signUpCellIdentifier = "signUpCell"

    var viewModel: MasterViewModel?

    // MARK:  Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        
        viewModel?.updatedContentSignal.subscribeNext({ [unowned self] (x) in
            self.reloadData()
        })
        
        initSpinner()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveExamResultHandler), name: "ReceiveExamResultNotification", object: nil)
    }
    
    func initSpinner()
    {
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.whiteColor()
        refreshControl!.tintColor = ThemeGreenColor
        refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
    }
    
    func reloadData()
    {
        viewModel?.reloadData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setEditing(false, animated: false)
        reloadData()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReceiveExamResultNotification", object: nil)
    }
    
    // MARK: - TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return viewModel!.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfRowsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        var reuseIdentifier: String
        let section = MasterViewControllerSection(rawValue: indexPath.section)!
        
        switch section
        {
        case .PaperSection:
            reuseIdentifier = (viewModel?.isIssuedAtIndexPath(indexPath) == true) ? reuseAfterExamCellIdentifier : reuseBeforeExamCellIdentifier
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
            configurePaperCell(cell, atIndexPath: indexPath)
        case .PPTSection:
            reuseIdentifier = pptCellIdentifier
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
            configurePPTCell(cell, atIndexPath: indexPath)
        case .ResourceSection:
            reuseIdentifier = undefineCellIdentifier
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
            configureResourceCell(cell, atIndexPath: indexPath)
        case .SignSection:
            reuseIdentifier = signUpCellIdentifier
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
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
            
            reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return viewModel?.titleForHeaderInSection(section)
    }

    // MARK: - Handler
    
    func receiveExamResultHandler(notification: NSNotification)
    {
        print("-----------------------Receive exam result: \(notification.userInfo)----------------------")
        if let resultDict = notification.userInfo {
            let paperName = resultDict["paper_title"] as! String
            if let indexPath = viewModel!.indexPathForPaperWithName(paperName) {
                viewModel?.addExamResultAtIndexPath(indexPath, resultDict: resultDict)
                viewModel?.addSignUpRecordWithData(resultDict)
            }
        }
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "createExam" {
            if let desVC = segue.destinationViewController as? PaperInformationViewController {
                desVC.viewModel = viewModel?.viewModelForNewPaper()
            }
        } else if segue.identifier == "editExam" {
            if let examViewController = segue.destinationViewController as? PaperInformationViewController {
                examViewController.viewModel = viewModel?.viewModelForExistPaper(indexPath!)
            }
        } else if segue.identifier == "showExamResult" {
            if let desVC = segue.destinationViewController as? ExamResultViewController {
                if let fileName = tableView.cellForRowAtIndexPath(indexPath!)?.textLabel?.text {
                    let url = ConvenientFileManager.paperURL.URLByAppendingPathComponent(fileName+"_result.plist")
                    desVC.fileURL = url
                }
            }
        }  else if segue.identifier == "undefineResource" {
            if let desVC = segue.destinationViewController as? UndefineResourceViewController {
                desVC.resourceURL = viewModel?.resourceURLAtIndexPath(indexPath!)
            }
        } else if segue.identifier == "displayPPT" {
            if let desVC = segue.destinationViewController as? PPTViewController {
                desVC.pptURL = viewModel?.pptURLAtIndexPath(indexPath!)
            }
        } else if segue.identifier == "showStudentList" {
            if let desVC = segue.destinationViewController as? StudentListViewController {
                desVC.viewModel = viewModel?.viewModelForStudentList()
            }
        } else if segue.identifier == "signUpSheet" {
            if let desVC = segue.destinationViewController as? SignUpSheetViewController {
                let signUpSheetName = tableView.cellForRowAtIndexPath(indexPath!)?.textLabel?.text
                let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName!)
                desVC.fileURL = signUpSheetURL
            }
        }
    }
 
}

// MARK: - DZNEmptyDataSet
private extension MasterViewController
{
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

