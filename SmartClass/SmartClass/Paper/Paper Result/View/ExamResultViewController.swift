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

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showChart" {
            if let desVC = segue.destinationViewController as? ChartViewController {
                desVC.dataSourceDict = configureChartViewDataSource()
            }
        } else if segue.identifier == "previewPaper" {
            if let desVC = segue.destinationViewController as? PreviewRootViewController {
                desVC.paper = paper
            }
        }
    }
    
}

extension ExamResultViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        } else {
            return results?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ResultHeaderCell", forIndexPath: indexPath) as! ResultHeaderCell
            
            cell.configureForPaper(paper)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ResultStudentCell", forIndexPath: indexPath) as! ResultStudentCell
            
            if let dict = results?[indexPath.row] as? NSDictionary {
                let name = dict["name"] as! String
                cell.nameLabel.text = name
                if let score = dict[paperName] as? Int {
                    cell.scoreLabel.text = "\(score)"
                    cell.scoreLabel.textColor = score > 60 ? ThemeGreenColor : ThemeRedColor
                } else {
                    cell.scoreLabel.text = NSLocalizedString("待考", comment: "")
                }
            }
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 64.0
        }
        return 44.0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0 {
            return nil
        }
        return NSLocalizedString("全部得分", comment: "")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0 {
            performSegueWithIdentifier("previewPaper", sender: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
}

// MARK: - Private method

private extension ExamResultViewController
{
    func configureChartViewDataSource() -> [String: Int]
    {
        // 统计及格人数、不及格人数、缺考人数
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
        
        // 统计试卷的每一题的答对人数
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
        let text = NSLocalizedString( "请先添加学生", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
