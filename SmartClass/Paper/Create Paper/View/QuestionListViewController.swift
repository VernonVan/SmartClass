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

    fileprivate var isChanged = false {
        didSet {
            if isChanged {
                navigationItem.leftBarButtonItem = doneBarButton
            }
        }
    }
    
    fileprivate let reuseIdentifier = "QuestionCell"
    
    fileprivate lazy var doneBarButton: UIBarButtonItem = {
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("确定", comment: ""), style: .plain, target: self, action: #selector(doneAction))
        doneBarButton.tintColor = ThemeBlueColor
        return doneBarButton
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    func doneAction()
    {
        intentResultDelegate?.selectQuestionAtIndex(0)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem)
    {
        if isChanged == true {
            intentResultDelegate?.selectQuestionAtIndex(0)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem)
    {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    // MARK: - Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfQuestions()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! QuestionCell

        let question = viewModel?.questionAtIndexPath((indexPath as NSIndexPath).row)
        cell.configurForQuestion(question)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if tableView.numberOfRows(inSection: 0) == 1 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if tableView.numberOfRows(inSection: 0) == 1 {
            setEditing(false, animated: true)
        }
        
        if editingStyle == .delete {
            isChanged = true
            viewModel?.deleteItemAtIndex((indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        intentResultDelegate?.selectQuestionAtIndex((indexPath as NSIndexPath).row)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 54.0
    }

}

protocol IntentResultDelegate
{
    func selectQuestionAtIndex(_ index: Int)
}
