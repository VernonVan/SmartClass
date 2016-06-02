//
//  PreviewPaperViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/5/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PreviewPaperViewController: UITableViewController
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

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseTopicCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseChoiceCell")
        
        tableView.scrollEnabled = false
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows = 0
        if section == 0 {
            rows = 1
        } else if section == 1 {
            rows = type == .TrueOrFalse ? 2 : 4
        }
        return rows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var reuseIdentifier = "reuseTopicCell"
        if indexPath.section == 1 {
            reuseIdentifier = "reuseChoiceCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        configureCell(cell, indexPath: indexPath)

        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath)
    {
        if indexPath.section == 0 {
            cell.textLabel?.text = question?.topic
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = question?.choiceA
                cell.imageView?.image = UIImage(named: "choiceA")
            case 1:
                cell.textLabel?.text = question?.choiceB
                cell.imageView?.image = UIImage(named: "choiceB")
            case 2:
                cell.textLabel?.text = question?.choiceC
                cell.imageView?.image = UIImage(named: "choiceC")
            case 3:
                cell.textLabel?.text = question?.choiceD
                cell.imageView?.image = UIImage(named: "choiceD")
            default:
                break
            }
            if question!.answers!.characters.contains(Character(UnicodeScalar(indexPath.row+65))) {
                cell.imageView?.image = UIImage(named: "correctAnswer")
            }
        }
    }
 
}
