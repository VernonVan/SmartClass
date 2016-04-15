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

class PaperViewController: UIViewController
{
    // MARK: - variable
    var viewModel: PaperViewModel?
    
    // MARK: - outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var questionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollViewHeight.constant = newButton.frame.maxY + 20.0
        
        removeBorderOfNavBar()
        
        bindViewModel()
        
        if let question = viewModel!.loadFirstQuestion() {
            printQuestion(question)
            let type = Int(question.type)
            viewModel!.type = type
            typeSegControl.selectedSegmentIndex = type
            questionView.changeQuestionType(QuestionType(rawValue: type)!)
            questionView.configureUIUsingQuestion(question)
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?)
    {
        if parent == nil {
            viewModel?.saveQuestion()
            viewModel?.save()
        }
    }
    
    // 去除NavigationBar的边界
    func removeBorderOfNavBar()
    {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.imageWithColor(ThemeGreenColor), forBarPosition: .Any, barMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
    }
    
    // MARK: - RAC binding
    func bindViewModel()
    {
        RACObserve(questionView, keyPath: "viewHeight") ~> RAC(questionViewHeight, "constant")
        
        RACObserve(viewModel, keyPath: "isEndQuestion").subscribeNext { [unowned self] (isEnd) in
            if let isEnd = isEnd as? Bool {
                self.newButton.hidden = !isEnd
            }
        }
        
        RACObserve(viewModel, keyPath: "questionIndex").subscribeNext { [unowned self] (index) in
            if let index = index as? Int {
                self.title = "第\(index+1)题"
            }
        }
        
        // bind question
        questionView.topicTextView.rac_textSignal() ~> RAC(viewModel, "topic")
        questionView.choiceTextFields[0].rac_textSignal() ~> RAC(viewModel, "choiceA")
        questionView.choiceTextFields[1].rac_textSignal() ~> RAC(viewModel, "choiceB")
        questionView.choiceTextFields[2].rac_textSignal() ~> RAC(viewModel, "choiceC")
        questionView.choiceTextFields[3].rac_textSignal() ~> RAC(viewModel, "choiceD")
        RACObserve(questionView, keyPath: "answers") ~> RAC(viewModel, "answers")
        scoreTextField.rac_textSignal() ~> RAC(viewModel, "score")
    }
    
    // MARK: - Actions
    
    @IBAction func changeQuestionType(sender: UISegmentedControl)
    {
        let type = sender.selectedSegmentIndex
        viewModel!.type = type
        
        questionView.changeQuestionType(QuestionType(rawValue: type)!)
    }
    
    @IBAction func lastAction(sender: UIButton)
    {
        viewModel?.saveQuestion()       // 保存当前题目
        if let question = viewModel!.loadLastQuestion() {
            printQuestion(question)
            clearScreenContent()                // 清空屏幕
            let type = Int(question.type)       // 加载上一题
            viewModel!.type = type
            typeSegControl.selectedSegmentIndex = type
            questionView.changeQuestionType(QuestionType(rawValue: type)!)
            questionView.configureUIUsingQuestion(question)
            viewModel!.configureUIUsingQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是第一题！", comment: ""), duration: 0.1, position: nil)
        }
    }

    @IBAction func nextAction(sender: UIButton)
    {
        viewModel?.saveQuestion()       // 保存当前题目
        if let question = viewModel!.loadNextQuestion() {
            printQuestion(question)
            clearScreenContent()                // 清空屏幕
            let type = Int(question.type)       // 加载下一题
            viewModel!.type = type
            typeSegControl.selectedSegmentIndex = type
            questionView.changeQuestionType(QuestionType(rawValue: type)!)
            questionView.configureUIUsingQuestion(question)
            viewModel!.configureUIUsingQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是最后一题！", comment: ""), duration: 0.1, position: nil)
        }
    }
    
    func printQuestion(question: Question)
    {
        print("Load")
        print("index: \(question.index+1)")
        print("type: \(question.type)")
        print("topic: \(question.topic)")
        print("choiceA: \(question.choiceA)")
        print("choiceB: \(question.choiceB)")
        print("choiceC: \(question.choiceC)")
        print("choiceD: \(question.choiceD)")
        print("answers: \(question.answers)")
        print("score: \(question.score)\n\n")
    }
    
    @IBAction func newAction(sender: UIButton)
    {
        viewModel!.saveQuestion()
        clearScreenContent()
        viewModel?.addQuestion()
        viewModel!.questionIndex += 1
    }
    
    func clearScreenContent()
    {
        questionView.clearScreenContent()
        scoreTextField.text = ""
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "showQuestionList" {
            
        }
    }
}
