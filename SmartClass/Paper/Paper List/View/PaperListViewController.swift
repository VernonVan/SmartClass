//
//  PaperListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift
import GCDWebServer
import Reachability
import DZNEmptyDataSet

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

enum PaperListVCSection: Int
{
    case editingPaperSection = 0
    case issuingPaperSection = 1
    case finishedPaperSection = 2
}

class PaperListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PaperListViewModel?
  
    fileprivate let disposeBag = DisposeBag()
    fileprivate let reuseIdentifier = "reusePaperCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
        
        // 接收网络状态的变化的通知
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    
    func initUI()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let webUploaderURL = appDelegate.webUploaderURL
        if webUploaderURL == nil {
            view.makeToast(NSLocalizedString("无法发布试卷，请确保Wifi网络可用", comment: ""))
        }
    }

    @IBAction func paperTypeChangeAction(_ segmentedControl: UISegmentedControl)
    {
        viewModel?.paperType = PaperType(rawValue: segmentedControl.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    func reachabilityChanged()
    {
        view.makeToast(NSLocalizedString("网络状态变化", comment: ""))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
    }
   
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "createPaper" {
            if let desVC = segue.destination as? PaperInformationViewController {
                desVC.viewModel = viewModel?.viewModelForNewPaper()
            }
        } else if segue.identifier == "editPaper" {
            if let examViewController = segue.destination as? PaperInformationViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                examViewController.viewModel = viewModel?.viewModelForExistPaper(indexPath)
            }
        } else if segue.identifier == "showIssuingPaper" {
            if let issuingPaperVC = segue.destination as? IssuingPaperViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                issuingPaperVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        } else if segue.identifier == "showExamResult" {
            if let desVC = segue.destination as? ResultContainerViewController {
                let indexPath = tableView.indexPathForSelectedRow!
//                print("试卷: \(viewModel?.paperAtIndexPath(indexPath))")
                desVC.paper = viewModel?.paperAtIndexPath(indexPath)
            }
        }
    }
}

// MARK: - TableView

extension PaperListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let number = viewModel!.numberOfPapers()
        tableView.separatorStyle = (number == 0 ? .none : .singleLine)
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PaperListCell
        let paper = viewModel?.paperAtIndexPath(indexPath)
        configureCell(cell, withPaper: paper)
        return cell
    }
    
    func configureCell(_ cell: PaperListCell, withPaper paper: Paper?)
    {
        cell.nameLabel?.text = paper?.name
        cell.blurbLabel?.text = paper?.blurb
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let paper = viewModel?.paperAtIndexPath(indexPath)
        switch PaperIssueState(rawValue: paper!.state)! {
        case .editing:
            performSegue(withIdentifier: "editPaper", sender: nil)
        case .issuing:
            performSegue(withIdentifier: "showIssuingPaper", sender: nil)
        case .finished:
            performSegue(withIdentifier: "showExamResult", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            viewModel!.deletePaperAtIndexPath(indexPath)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return viewModel?.paperAtIndexPath(indexPath).blurb.length > 0 ? PaperListCell.cellHeight : 44.0
    }
}

// MARK: - DZNEmptyDataSet

extension PaperListViewController: DZNEmptyDataSetSource
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyPaper")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("点击右上角+开始创建试卷", comment: "" )
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text , attributes: attributes)
    }

}
