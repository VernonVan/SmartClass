//
//  AddQuestionsViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

enum QuestionType: Int {
    case SingleChoice=0, MultipleChoice, TrueOrFalse
}

enum Options: Int {
    case optionA, optionB, optionC, optionD
}

class AddQuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - constants
    
    private let VerticalSpace: CGFloat = 8.0
    private let ExtraSpace: CGFloat = 50.0
    private let CellHeight: CGFloat = 40.0
    
    // MARK: - variable
    
    private var questionType = QuestionType.SingleChoice
    private var cellNumber = 4
    
    // MARK: - outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topicTextView: UITextView!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 去除NavigationBar的边界
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.imageWithColor(ThemeGreenColor), forBarPosition: .Any, barMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
    
        scrollViewHeight.constant = calculateScrollViewHeight()
        
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.alwaysBounceVertical = false
        optionTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    // MARK: - Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseOption", forIndexPath: indexPath) as! OptionCell
        configureCell(cell, option: Options(rawValue: indexPath.row)!)
        return cell
    }
    
    func configureCell(cell: OptionCell, option: Options)
    {
        switch option {
        case .optionA:
            cell.optionImg.image = UIImage(named: "optionA")
        case .optionB:
            cell.optionImg.image = UIImage(named: "optionB")
        case .optionC:
            cell.optionImg.image = UIImage(named: "optionC")
        case .optionD:
            cell.optionImg.image = UIImage(named: "optionD")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CellHeight
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // MARK: - question type
    
    @IBAction func changeTypeAction(segment: UISegmentedControl)
    {
        questionType = QuestionType(rawValue: segment.selectedSegmentIndex)!
        changeType(questionType)
    }
    
    func changeType(type: QuestionType)
    {
        switch type {
        case .SingleChoice:
            cellNumber = 4
            tableviewHeight.constant = 4*CellHeight
        case .MultipleChoice:
            cellNumber = 4
            tableviewHeight.constant = 4*CellHeight
        case .TrueOrFalse:
            cellNumber = 2
            tableviewHeight.constant = 2*CellHeight
        }
        
        optionTableView.reloadData()
    }
    
    // MARK: - scroll
    
    func calculateScrollViewHeight() -> CGFloat
    {
        return topicTextView.bounds.height + optionTableView.bounds.height + 2*VerticalSpace
            + scoreTextField.bounds.height + nextButton.bounds.height + ExtraSpace
    }
    
}
