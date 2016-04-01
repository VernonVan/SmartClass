//
//  StudentMainInterfaceTableViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class StudentMainInterfaceTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let nav = navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 0.49 , green: 0.70 , blue: 0.26 , alpha: 100 )         //修改导航栏的颜色
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]       //修改Title颜色
        nav?.translucent = false
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
