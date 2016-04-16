//
//  ExamMessageViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/16.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ExamMessageViewController: UIViewController
{
    var exam: Examination?
    
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.countDownDuration = NSTimeInterval(integerLiteral: 5400)
    }
    
    // MARK: - Actions
    
    @IBAction func startExamAction(sender: AnyObject)
    {
        let alert = UIAlertController(title: NSLocalizedString("确定开始考试吗？", comment: ""), message: nil, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default, handler: { action in
                self.performSegueWithIdentifier("startExam", sender: sender)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
