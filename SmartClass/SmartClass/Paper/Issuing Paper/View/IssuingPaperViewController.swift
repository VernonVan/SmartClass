//
//  IssuingPaperViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class IssuingPaperViewController: UIViewController
{
    var paper: Paper?
    
    @IBOutlet weak var doneNumberLabel: UILabel!
    @IBOutlet weak var absentNumberLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = paper?.name
        
        refresh()
    }
    
    // MARK: - Action
    
    @IBAction func refreshAction(sender: UIBarButtonItem)
    {
        refresh()
    }
    
    @IBAction func finishExamAction()
    {
        let alert = UIAlertController(title: NSLocalizedString("结束考试？", comment: ""), message: NSLocalizedString("结束考试后学生都不能再进行考试！", comment: ""), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .Destructive, handler: nil)
        alert.addAction(cancelAction)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default) { [weak self] (_) in
            self?.finishExam()
        }
        alert.addAction(doneAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "previewPaper" {
            if let desVC = segue.destinationViewController as? PreviewRootViewController {
                desVC.paper = paper
            }
        }
    }
    
    // MARK: - Private method
    
    func refresh()
    {
        let results = NSArray(contentsOfURL: ConvenientFileManager.studentListURL)
        let studentNumber = results?.count ?? 0
        if studentNumber == 0 {
            // 尚未添加任何学生
            doneNumberLabel.text = nil
            absentNumberLabel.text = NSLocalizedString("尚未添加学生！", comment: "")
        } else {
            let paperName = paper?.name
            var doneNumber = 0, absentNumber = 0
            
            for (_, obj) in results!.enumerate() {
                if let dict = obj as? NSDictionary, let _ = dict[paperName!] as? Int {
                    doneNumber += 1
                } else {
                    absentNumber += 1
                }
            }
            
            let doneNumberText = NSMutableAttributedString(string: "已交卷人数：\(doneNumber)")
            doneNumberText.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkTextColor(), range: NSRange(location: 0, length: 6))
            doneNumberText.addAttribute(NSForegroundColorAttributeName, value: ThemeGreenColor, range: NSRange(location: 6, length: doneNumberText.length-6))
            doneNumberLabel.attributedText = doneNumberText
            
            let absentNumberText = NSMutableAttributedString(string: "未交卷人数：\(absentNumber)")
            absentNumberText.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkTextColor(), range: NSRange(location: 0, length: 6))
            absentNumberText.addAttribute(NSForegroundColorAttributeName, value: ThemeRedColor, range: NSRange(location: 6, length: absentNumberText.length-6))
            absentNumberLabel.attributedText = absentNumberText
        }
    }
    
    func finishExam()
    {
        paper?.issueState = PaperIssueState.finished.rawValue
        CoreDataStack.defaultStack.saveContext()
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
