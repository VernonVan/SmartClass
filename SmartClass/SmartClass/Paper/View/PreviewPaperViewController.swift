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
    var viewModel: PreviewPaperViewModel?
    var a : UIPageViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
