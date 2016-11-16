//
//  SignUpSheetListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SignUpSheetListViewController: UIViewController
{
    var viewModel: SignUpSheetListViewModel?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        initUI()
    }

    func initUI()
    {
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        viewModel?.reloadData()
        tableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SignUpSheet" {
            if let desVC = segue.destination as? SignUpSheetViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                let name =  viewModel?.titleForSignUpSheetAtIndexPath(indexPath)
                desVC.signUpName = name
            }
        }
    }

}

// MARK: - Table View

extension SignUpSheetListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = viewModel?.numberOfSignUpSheet() ?? 0
        tableView.separatorStyle = (count == 0 ? .none : .singleLine)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpSheetListCell", for: indexPath)
        cell.textLabel?.text = viewModel?.titleForSignUpSheetAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            viewModel?.deleteSignUpSheetAtIndexPath(indexPath)
            tableView.reloadData()
        }
    }
}

// MARK: - DZNEmptyDataSet

extension SignUpSheetListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptySignUpSheet")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("没有签到记录", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text , attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("点击右上角+开始签到（学生进行考试也会自动签到）", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14.0),
                          NSForegroundColorAttributeName : UIColor.lightGray]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
}
