//
//  PreviewPaperViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/5/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PreviewPaperViewController: UIViewController, UITableViewDataSource
{
    var question: Question?
    lazy var type: QuestionType? = {
        switch self.question?.type {
        case .Some(0):
            return .SingleChoice
        case .Some(1):
            return .MultipleChoice
        case .Some(2):
            return .TrueOrFalse
        default:
            return nil
        }
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .Plain)
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(netHex: 0xF5F5F5)
        tableView.registerNib(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "TopicCell")
        tableView.registerNib(UINib(nibName: "ChoiceCell", bundle: nil), forCellReuseIdentifier: "ChoiceCell")
        return tableView
    }()
    
    init(question: Question?)
    {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows = 0
        if section == 0 {
            rows = 1
        } else if section == 1 {
            rows = type == .TrueOrFalse ? 2 : 4
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as! TopicCell
            cell.configureForQuestion(question!)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! ChoiceCell
            cell.configureForQuestion(question!, choiceNum: indexPath.row)
            return cell
        }
    }
 
}
