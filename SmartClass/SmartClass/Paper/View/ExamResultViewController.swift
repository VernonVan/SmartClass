//
//  ExamResultViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ExamResultViewController: UITableViewController
{
    lazy var results: NSArray? = {
        let studentListURL = ConvenientFileManager.studentListURL
        let results = NSArray(contentsOfURL: studentListURL)
        return results
    }()
  
    var paper: Paper?
    lazy var paperName: String = {
        return self.paper!.name!
    }()
    lazy var questionNumber: Int = {
        return self.paper!.questions!.count
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = results?.count ?? 0
        if count == 0 {
            tableView.separatorStyle = .None
            navigationItem.rightBarButtonItem = nil
        } else {
            tableView.separatorStyle = .SingleLine
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseExamResultCell", forIndexPath: indexPath)
        
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        if let dict = results?[indexPath.row] as? NSDictionary {
            let name = dict["name"] as! String
            cell.textLabel?.text = name
            if let score = dict[paperName] as? Int {
                cell.detailTextLabel?.text = "\(score)"
                cell.detailTextLabel?.textColor = score > 60 ? ThemeGreenColor : ThemeRedColor
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("待考", comment: "")
            }
        }
        
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showChart" {
            if let desVC = segue.destinationViewController as? ChartViewController {
                desVC.dataSourceDict = configureChartViewDataSource()
            }
        } else if segue.identifier == "previewPaper" {
            if let desVC = segue.destinationViewController as? PreviewPaperViewController {
                desVC.viewModel = PreviewPaperViewModel(paper: paper!)
            }
        }
    }
    
    func configureChartViewDataSource() -> [String: Int]
    {
        var passStudents = 0, failStudents = 0, absentStudents = 0
        for (_, obj) in results!.enumerate() {
            if let dict = obj as? NSDictionary, let score = dict[paperName] as? Int {
                if score > 60 {
                    passStudents += 1
                } else {
                    failStudents += 1
                }
            } else {
                absentStudents += 1
            }
        }
        
        var questions = [Int]()
        for index in 0 ..< self.questionNumber {
            questions.insert(0, atIndex: index)
        }
        
        let paperResultURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paperName + "_result.plist")
        if let paperResults = NSArray(contentsOfURL: paperResultURL) {
            for (_, obj) in paperResults.enumerate() {
                if let dict = obj as? NSDictionary {
                    if let name = dict["name"] as? String, let correctQuestions = dict["correctQuestions"] as? [Int] {
                        if studentListHasStudentName(name) {
                            for index in correctQuestions {
                                questions[index] += 1
                            }
                        }
                    }
                }
            }
        }
        
        var tempDict = ["passStudents": passStudents, "failStudents": failStudents, "absentStudents": absentStudents, "questionNumber": questionNumber]
        for index in 0 ..< self.questionNumber {
            tempDict["\(index)"] = questions[index]
        }

        return tempDict
    }
    
    func studentListHasStudentName(name: String) -> Bool
    {
        for (_, obj) in results!.enumerate() {
            if let dict = obj as? NSDictionary, let tempName = dict["name"] as? String {
                if tempName == name {
                    return true
                }
            }
        }
        
        return false
    }
    
}

// MARK: - DZNEmptyDataSetSource
extension ExamResultViewController: DZNEmptyDataSetSource
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "还未添加学生", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString( "这里应该是跳转到添加学生界面的按钮", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0) ,
                          NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }
}
