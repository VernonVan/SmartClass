//
//  ResourceListViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import QuickLook
import DZNEmptyDataSet

class ResourceListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ResourceListViewModel?

    fileprivate let reuseIdentifier = "resourceCell"
    fileprivate var selectedIndexPath = IndexPath()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ThemeBlueColor
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    func refresh(_ refreshControl: UIRefreshControl)
    {
        DispatchQueue.global(qos: .default).async {
            self.viewModel?.reloadData()
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            })
        }      
    }
    
    @IBAction func changeDataSourceAction(_ segmentedControl: UISegmentedControl)
    {
        tableView.reloadData()
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "displayPPT" {
            if let desVC = segue.destination as? PPTDisplayViewController {
//                print("before pptURL: \(pptURL)")
                desVC.pptURL = viewModel?.pptURLAtIndexPath(indexPath!) as NSURL?
            }
        }
    }
}

// MARK: - UITableView 

extension ResourceListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var number = 0
        
        if segmentedControl.selectedSegmentIndex == 0 {
            number = viewModel!.numberOfPPT()
        } else {
            number = viewModel!.numberOfResource()
        }
        
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ResourceCell
        if segmentedControl.selectedSegmentIndex == 0 {
            let ppt = viewModel?.pptAtIndexPath(indexPath)
            cell.configureCellForPPT(ppt)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let resource = viewModel?.resourceAtIndexPath(indexPath)
            cell.configureCellForResource(resource)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if segmentedControl.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "displayPPT", sender: nil)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let previewController = QLPreviewController()
            selectedIndexPath = indexPath
            previewController.dataSource = self
            present(previewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            if segmentedControl.selectedSegmentIndex == 0 {
                _ = viewModel?.deletePPTAtIndexPath(indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else if segmentedControl.selectedSegmentIndex == 1 {
                _ = viewModel?.deleteResourceAtIndexPath(indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.reloadEmptyDataSet()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return ResourceCell.cellHeight
    }
}

// MARK: - QLPreviewController

extension ResourceListViewController: QLPreviewControllerDataSource
{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int
    {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem
    {
        return viewModel!.resourceURLAtIndexPath(selectedIndexPath) as QLPreviewItem
    }

    
}

// MARK: - DZNEmptyDataSet

extension ResourceListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyResource")
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("还未添加资源", comment: "" )
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16.0) ,
                          NSForegroundColorAttributeName : UIColor.darkGray]
        return NSAttributedString(string: text , attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var text = ""
        if let webUploadURL = appDelegate.webUploaderURL {
            text = "访问\(webUploadURL.absoluteString + "admin/")上传资源"
        } else{
            text = NSLocalizedString("打开Wifi方可上传资源", comment: "" )
        }
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.lightGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
}
