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
    private let reuseIdentifier = "reuseQuestionCell"
    
    
    // MARK: - variable
    var viewModel: QuestionListViewModel?
    var intentResultDelegate: IntentResultDelegate?
    
    private var isChanged = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem()
    }

    override func willMoveToParentViewController(parent: UIViewController?)
    {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if isChanged == true {
                intentResultDelegate?.selectQuestionAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.imageView?.image = UIImage(named: viewModel!.imageNameAtIndexPath(indexPath))
        cell.textLabel?.text = viewModel?.titleAtIndexPath(indexPath)
        cell.accessoryView = UIImageView(image: UIImage(named: viewModel!.accessoryImageNameAtIndexPath(indexPath)))

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
            viewModel?.deleteItemAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        isChanged = true
        viewModel?.moveItemFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK: - table view delegate 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        intentResultDelegate?.selectQuestionAtIndexPath(indexPath)
        navigationController?.popViewControllerAnimated(true)
    }

}
