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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
