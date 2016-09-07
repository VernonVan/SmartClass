//
//  QuestionListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/4.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QuestionListViewController: UITableViewController
{

    var viewModel: QuestionListViewModel?
    var intentResultDelegate: IntentResultDelegate?

    private var isChanged = false {
        didSet {
            if isChanged {
                navigationItem.leftBarButtonItem = doneBarButton
            }
        }
    }
    
    private let reuseIdentifier = "QuestionCell"
    
    private lazy var doneBarButton: UIBarButtonItem = {
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("确定", comment: ""), style: .Plain, target: self, action: #selector(doneAction))
        doneBarButton.tintColor = ThemeBlueColor
        return doneBarButton
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.rightBarButtonItem = editButtonItem()
    }

    override func willMoveToParentViewController(parent: UIViewController?)
    {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if isChanged == true {
                intentResultDelegate?.selectQuestionAtIndex(0)
            }
        }
    }

    func doneAction()
    {
        intentResultDelegate?.selectQuestionAtIndex(0)
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfQuestions()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QuestionCell

        let question = viewModel?.questionAtIndexPath(indexPath.row)
        cell.configurForQuestion(question)

        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if tableView.numberOfRowsInSection(0) == 1 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView.numberOfRowsInSection(0) == 1 {
            setEditing(false, animated: true)
        }
        
        if editingStyle == .Delete {
            isChanged = true
            viewModel?.deleteItemAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        intentResultDelegate?.selectQuestionAtIndex(indexPath.row)
        navigationController?.popViewControllerAnimated(true)
    }

}

protocol IntentResultDelegate
{
    func selectQuestionAtIndex(index: Int)
}
