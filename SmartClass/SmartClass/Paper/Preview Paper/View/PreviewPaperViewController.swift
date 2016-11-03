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
        case .some(0):
            return .singleChoice
        case .some(1):
            return .multipleChoice
        case .some(2):
            return .trueOrFalse
        default:
            return nil
        }
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(netHex: 0xF5F5F5)
        tableView.register(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "TopicCell")
        tableView.register(UINib(nibName: "ChoiceCell", bundle: nil), forCellReuseIdentifier: "ChoiceCell")
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

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows = 0
        if section == 0 {
            rows = 1
        } else if section == 1 {
            rows = type == .trueOrFalse ? 2 : 4
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicCell
            cell.configureForQuestion(question!)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceCell", for: indexPath) as! ChoiceCell
            cell.configureForQuestion(question!, choiceNum: (indexPath as NSIndexPath).row)
            return cell
        }
    }
 
}
