//
//  PaperView.swift
//  SmartClass
//
//  Created by Vernon on 16/4/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import SnapKit

class QuestionView: UIView, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Properties
    dynamic var viewHeight: CGFloat = 244.0
    
    private let tableview = UITableView()
    private let topicCell = UITableViewCell()
    private let topicTextView = UIPlaceHolderTextView()
    private var choiceCells =  [UITableViewCell]()
    private var choiceTextFields = [UITextField]()
//    private var choiceCount: Int {
//        return questionType==QuestionType.TrueOrFalse ? 2 : 4
//    }
    private var questionType = QuestionType.SingleChoice {
        didSet {
            viewHeight = (questionType == .TrueOrFalse) ? TrueOrFalseHeight : ChoiceViewHeight
        }
    }
    private var previousType = QuestionType.SingleChoice
    
    // MARK: - Constants
    
    private let ChoiceViewHeight: CGFloat = 244.0
    private let TrueOrFalseHeight: CGFloat = 156.0
    private let TopicCellHeight: CGFloat = 68.0
    private let ChoiceCellHeight: CGFloat = 44.0
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        tableview.dataSource = self
        tableview.delegate = self
        self.addSubview(tableview)
        tableview.scrollEnabled = false
        tableview.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        configureTopicCell()
        configureChoiceCells()
        
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }
        return choiceCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            return topicCell
        }
        return choiceCells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return (indexPath.section==0) ? TopicCellHeight : ChoiceCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.imageView?.image = UIImage(named: "correctAnswer")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.imageView?.image = UIImage(named: getChoiceImageName(indexPath.row))
    }
    
    
    // MARK: - Cell
    
    func configureTopicCell()
    {
        topicTextView.placeholder = NSLocalizedString("问题描述", comment: "")
        topicTextView.font = UIFont.systemFontOfSize(14)
        topicCell.addSubview(topicTextView)
        topicTextView.snp_makeConstraints { (make) in
            make.edges.equalTo(topicCell).inset(UIEdgeInsetsZero)
        }
    }
    
    func configureChoiceCells()
    {
        for index in 0..<4 {
            let choiceCell = UITableViewCell()
            let choiceTextField = UITextField()
            choiceCell.imageView?.image = UIImage(named: getChoiceImageName(index))
            
            choiceTextField.borderStyle = .None
            choiceTextField.placeholder = NSLocalizedString("选项", comment: "")
            choiceCell.addSubview(choiceTextField)
            choiceTextField.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(choiceCell)
                make.left.equalTo(45)
                make.right.equalTo(2)
            })
            
            choiceTextFields.append(choiceTextField)
            choiceCells.append(choiceCell)
        }
    }
    
    func clearAllSelection()
    {
        for row in 0..<4 {
            let indexPath = NSIndexPath(forRow: row, inSection: 1)
            tableview.deselectRowAtIndexPath(indexPath, animated: false)
            let cell = tableview.cellForRowAtIndexPath(indexPath)
            cell?.imageView?.image = UIImage(named: getChoiceImageName(indexPath.row))
        }
        
    }
    
    // 从序号转换成图片的name
    func getChoiceImageName(index: Int) -> String
    {
        return String(format: "option%c", index+65)
    }
    
    func changeQuestionType(questionType: QuestionType)
    {
        previousType = self.questionType
        clearAllSelection()
        switch questionType {
        case .SingleChoice:
            changeToSingleChoice()
        case .MultipleChoice:
            changeToMultipleChoice()
        case .TrueOrFalse:
            changeToTrueOrFalse()
        }
        self.questionType = questionType
    }
    
    func changeToSingleChoice()
    {
        tableview.allowsMultipleSelection = false
        if previousType == .TrueOrFalse {
            clearAllChoiceText()
        }
    }
    
    func changeToMultipleChoice()
    {
        tableview.allowsMultipleSelection = true
        if previousType == .TrueOrFalse {
            clearAllChoiceText()
        }
    }
    
    func changeToTrueOrFalse()
    {
        tableview.allowsMultipleSelection = false
        choiceTextFields[0].text = NSLocalizedString("正确", comment: "")
        choiceTextFields[1].text = NSLocalizedString("错误", comment: "")
    }
    
    func clearAllChoiceText()
    {
        for textField in choiceTextFields {
            textField.text = ""
        }
    }
    
}
