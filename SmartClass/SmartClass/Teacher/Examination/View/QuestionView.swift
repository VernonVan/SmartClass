//
//  PaperView.swift
//  SmartClass
//
//  Created by Vernon on 16/4/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QuestionView: UIView, UITableViewDataSource
{
    // MARK: - Properties
    
    private let tableview = UITableView()
    var questionType = QuestionType.SingleChoice {
        didSet {
            setNeedsDisplay()
        }
    }
    private var choiceCount: Int {
        return questionType==QuestionType.TrueOrFalse ? 2 : 4
    }
    private let topicCell = UITableViewCell()
 //   private let choiceCells =  [UITableViewCell]()
    private let scoreCell = UITableViewCell()
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        tableview.frame = bounds
        tableview.dataSource = self
        topicCell.frame = CGRect(x: 12, y: 20, width: 40, height: 50)
        topicCell.textLabel?.text = "123fewwwwwwwwwwwwwwwwwwwwwwwwwwwww"
        self.addSubview(tableview)
    }
    
    override func layoutSubviews()
    {
        tableview.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
//        case 1:
//            return 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            return topicCell
//        case 1:
//            return choiceCells[indexPath.row]
        case 1:
            return scoreCell
        default:
            return UITableViewCell()
        }
    }
    
}
