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
    
    // MARK: - var
    private let tableview = UITableView()
    private let topicCell = UITableViewCell()
    let topicTextView = UIPlaceHolderTextView()
    private var choiceCells =  [UITableViewCell]()
    var choiceTextFields = [UITextField]()
    dynamic var answers: String? = ""
    private var questionType = QuestionType.SingleChoice {
        didSet {
            viewHeight = (questionType == .TrueOrFalse) ? TrueOrFalseHeight : ChoiceViewHeight
        }
    }
    private var previousType = QuestionType.SingleChoice
    
    // MARK: - Constants
    private let numberOfSection = 2
    private let TopicSection = 0
    private let ChoiceSection = 1
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
        addSubview(tableview)
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
            self.paperViewModel?.topic = topic as? String
        }
        choiceTextFields[0].rac_textSignal().subscribeNext { [unowned self] (choiceA) in
            self.paperViewModel?.choiceA = choiceA as? String
        }
        choiceTextFields[1].rac_textSignal().subscribeNext { [unowned self] (choiceB) in
            self.paperViewModel?.choiceB = choiceB as? String
        }
        choiceTextFields[2].rac_textSignal().subscribeNext { [unowned self] (choiceC) in
            self.paperViewModel?.choiceC = choiceC as? String
        }
        choiceTextFields[3].rac_textSignal().subscribeNext { [unowned self] (choiceD) in
            self.paperViewModel?.choiceD = choiceD as? String
        }

        RACObserve(self, keyPath: "answers").subscribeNext { [unowned self] (answers) in
            self.paperViewModel?.answers = answers as? String
        }
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
        } else if section == ChoiceSection {
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
        return (indexPath.section == 0) ? TopicCellHeight : ChoiceCellHeight
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
        cell?.imageView?.image = UIImage(named: "emptyChoice")
        changeAnswers()
    }
    
    func changeAnswers()
    {
        if let indexPaths = tableview.indexPathsForSelectedRows {
            let sortedIndexPaths = indexPaths.sort({ (indexPath1, indexPath2) -> Bool in
                return indexPath1.row > indexPath2.row
            })
            answers = ""
            for indexPath in sortedIndexPaths {
                answers?.append(Character(UnicodeScalar(indexPath.row+65)))
            }
        }
    }
    
    // MARK: - tableView cell
    
    func configureTopicCell()
    {
        topicTextView.placeholder = NSLocalizedString("问题描述", comment: "")
        topicTextView.autocorrectionType = .No
        topicTextView.font = UIFont.systemFontOfSize(14)
        topicCell.addSubview(topicTextView)
        topicTextView.snp_makeConstraints { (make) in
            make.edges.equalTo(topicCell).inset(UIEdgeInsetsZero)
        }
    }
    
    func configureChoiceCells()
    {
        for index in 0 ..< 4 {
            let choiceCell = UITableViewCell()
            let choiceTextField = UITextField()
            choiceTextField.autocorrectionType = .No
            choiceCell.imageView?.image = UIImage(named: "emptyChoice")
            
            choiceTextField.borderStyle = .None
            choiceTextField.placeholder = String(format: "选项%c", index+65)
            choiceCell.addSubview(choiceTextField)
            choiceTextField.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(choiceCell)
                make.left.equalTo(choiceCell.imageView!).offset(44)
                make.right.equalTo(choiceCell).inset(10)
            })
            
            choiceTextFields.append(choiceTextField)
            choiceCells.append(choiceCell)
        }
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
        topicTextView.text = nil
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
            let indexPath = NSIndexPath(forRow: row, inSection: ChoiceSection)
            tableview.deselectRowAtIndexPath(indexPath, animated: false)
            let cell = tableview.cellForRowAtIndexPath(indexPath)
            cell?.imageView?.image = UIImage(named: "emptyChoice")
        }
        answers = nil
    }
    
    // MARK: - configure UI
    
    func configureUIUsingQuestion(question: Question)
    {
        changeQuestionType(QuestionType(rawValue: Int(question.type))!)
        topicTextView.text = question.topic
        choiceTextFields[0].text = question.choiceA
        choiceTextFields[1].text = question.choiceB
        choiceTextFields[2].text = question.choiceC
        choiceTextFields[3].text = question.choiceD
        
        configureSelectionsUsingAnswers(question.answers)
    }
    
    func configureSelectionsUsingAnswers(answers: String?)
    {
        if let answers = answers {
            dispatch_async(dispatch_get_main_queue()) {
                for selection in answers.characters {
                    self.selectChoice(selection)
                }
                self.changeAnswers()
            }
        }
    }
    
    func selectChoice(choice: Character)
    {
        let row = Int(choice.unicodeScalarCodePoint()) - 65
        let indexPath = NSIndexPath(forRow: row, inSection: self.ChoiceSection)
        
        tableview.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.imageView?.image = UIImage(named: "correctAnswer")
    }

}

