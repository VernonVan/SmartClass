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
    // MARK: - APIs
    dynamic var viewHeight: CGFloat = 244.0
    
    weak var paperViewModel: PaperViewModel?
    
    // MARK: - private var
    private let tableview = UITableView()
    private let topicCell = UITableViewCell()
    let topicTextView = UIPlaceHolderTextView()
    private var choiceCells =  [UITableViewCell]()
    var choiceTextFields = [UITextField]()
    dynamic var answers = ""
    private var questionType = QuestionType.SingleChoice {
        didSet {
            viewHeight = (questionType == .TrueOrFalse) ? TrueOrFalseHeight : ChoiceViewHeight
        }
    }
    private var previousType = QuestionType.SingleChoice
    
    // MARK: - Constants
    private let numberOfSection = 2
    private let TopicSection = 0
    private let OptionSection = 1
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
    
    override func didMoveToWindow()
    {
        super.didMoveToWindow()
        bindViewModel()
    }
    
    // MARK: - RAC binding
    
    func bindViewModel()
    {
        topicTextView.rac_textSignal().subscribeNext { [unowned self] (topic) in
            self.paperViewModel?.topic = topic as! String
        }
        choiceTextFields[0].rac_textSignal().subscribeNext { [unowned self] (choiceA) in
            self.paperViewModel?.choiceA = choiceA as! String
        }
        choiceTextFields[1].rac_textSignal().subscribeNext { [unowned self] (choiceB) in
            self.paperViewModel?.choiceB = choiceB as! String
        }
        choiceTextFields[2].rac_textSignal().subscribeNext { [unowned self] (choiceC) in
            self.paperViewModel?.choiceC = choiceC as! String
        }
        choiceTextFields[3].rac_textSignal().subscribeNext { [unowned self] (choiceD) in
            self.paperViewModel?.choiceD = choiceD as! String
        }

//        RACObserve(self, keyPath: "answers") ~> RAC(paperViewModel, "answers")
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    { 
        return numberOfSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == TopicSection {
            return 1
        } else if section == OptionSection {
            return choiceCells.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == TopicSection {
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
        changeAnswers()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.imageView?.image = UIImage(named: getChoiceImageName(indexPath.row))
    }
    
    func changeAnswers()
    {
        let indexPaths = tableview.indexPathsForSelectedRows
        answers = ""
        for indexPath in indexPaths! {
            answers += String(format: "%c", indexPath.row+65)
        }
    }
    
    // MARK: - tableView cell
    
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

    // 从序号转换成图片的name
    func getChoiceImageName(index: Int) -> String
    {
        return String(format: "option%c", index+65)
    }
    
    // MARK: - Question type
    
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
        clearAllChoiceText()
    }
    
    // MARK: - clear screen
    func clearScreenContent()
    {
        clearAllChoiceText()
        clearAllSelection()
        topicTextView.text = ""
    }
    
    func clearAllChoiceText()
    {
        for textField in choiceTextFields {
            textField.text = nil
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
    
    func configureUIUsingQuestion(question: Question)
    {
        changeQuestionType(QuestionType(rawValue: Int(question.type))!)
        topicTextView.text = question.topic
        choiceTextFields[0].text = question.choiceA
        choiceTextFields[1].text = question.choiceB
        choiceTextFields[2].text = question.choiceC
        choiceTextFields[3].text = question.choiceD
    }
    
}

