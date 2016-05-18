//
//  SignUpSheetViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/3.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class SignUpSheetViewController: UITableViewController
{
    private var records: NSArray?
    var signUpName: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let fileURL = ConvenientFileManager.studentListURL
        records = NSArray(contentsOfURL: fileURL)
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return records!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseSignUpCell", forIndexPath: indexPath)

        configureCellAtIndexPath(cell, atIndexPath: indexPath)

        return cell
    }
    
    func configureCellAtIndexPath(cell: UITableViewCell, atIndexPath indexPath : NSIndexPath)
    {
        if let dict = records?[indexPath.row] as? NSDictionary {
            let name = dict["name"] as! String
            let number = dict["number"] as! String
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = number
            
            if let signed = dict[signUpName!] as? Bool where signed == true {
                cell.accessoryType = .Checkmark
            } else {
                let label = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 88.0, height: 44.0)))
                label.textAlignment = .Right
                let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(16.0) ,
                                  NSForegroundColorAttributeName : ThemeLightGreyColor]
                label.attributedText = NSAttributedString(string: NSLocalizedString( "未签到", comment: "" ) , attributes: attributes)
                cell.accessoryView = label
            }
        }
        
    }

}
