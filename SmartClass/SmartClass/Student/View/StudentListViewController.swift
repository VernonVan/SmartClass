//
//  StudentListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast
import DZNEmptyDataSet

protocol StudentInformationDelegate
{
    func addStudent(_ student: Student)
    func modifyStudentAtIndexPath(_ indexPath: IndexPath, newStudent student: Student)
}

class StudentListViewController: UIViewController
{
    var viewModel: StudentListViewModel?
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()

        addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4.0)
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "modifyStudent" {
            if let desVC = segue.destination as? StudentInformationViewController {
                let indexPath = tableView.indexPathForSelectedRow
                desVC.indexPath = indexPath
                desVC.student = viewModel?.studentAtIndexPath(indexPath!)
                desVC.delegate = self
            }
        } else if segue.identifier == "addStudent" {
            if let desVC = segue.destination as? StudentInformationViewController {
                desVC.delegate = self
            }
        }
    }
    
}

// MARK: - Table view

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = viewModel!.numberOfStudents()
        tableView.separatorStyle = count == 0 ? .none : .singleLine
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        configureCellAtIndexPath(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCellAtIndexPath(_ cell: StudentCell, atIndexPath indexPath: IndexPath)
    {
        cell.nameLabel?.text = "\(viewModel!.nameAtIndexPath(indexPath))  \(viewModel!.numberAtIndexPath(indexPath))"
        cell.majorLabel?.text = "\(viewModel!.schoolAtIndexPath(indexPath))  \(viewModel!.majorAtIndexPath(indexPath))"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            viewModel?.deleteStudentAtIndexPath(indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return StudentCell.cellHeight
    }
}

// MARK: - StudentInformationDelegate

extension StudentListViewController: StudentInformationDelegate
{
    func addStudent(_ student: Student)
    {
        viewModel?.addStudent(student)
        tableView.reloadData()
    }
    
    func modifyStudentAtIndexPath(_ indexPath: IndexPath, newStudent student: Student)
    {
        viewModel?.modifyStudentAtIndexPath(indexPath, newStudent: student)
        tableView.reloadData()
    }
}

// MARK: - DZNEmptyDataSet

extension StudentListViewController: DZNEmptyDataSetSource
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyStudent")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("尚未添加学生", comment: "")
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
