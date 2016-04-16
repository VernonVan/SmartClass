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
        
        questionView.paperViewModel = viewModel
        bindViewModel()
        
        if let question = viewModel!.loadFirstQuestion() {
            configureUIUsingQuestion(question)
            scoreTextField.text = String(question.score)
            viewModel?.configureUIUsingQuestion(question)
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?)
    {
        super.willMoveToParentViewController(parent)
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
    
        scoreTextField.rac_textSignal().subscribeNext { [unowned self] (score) in
            if let score = score as? String {
                self.viewModel?.score = Int(score)
            }
        }
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
            clearScreenContent()                // 清空屏幕
            configureUIUsingQuestion(question)
            scoreTextField.text = String(question.score)
            viewModel?.configureUIUsingQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是第一题！", comment: ""), duration: 0.1, position: nil)
        }
        
    }

    @IBAction func nextAction(sender: UIButton)
    {
        viewModel?.saveQuestion()       // 保存当前题目
        if let question = viewModel!.loadNextQuestion() {
            clearScreenContent()                // 清空屏幕
            configureUIUsingQuestion(question)
            scoreTextField.text = String(question.score)
            viewModel?.configureUIUsingQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是最后一题！", comment: ""), duration: 0.1, position: nil)
        }
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
    
    func configureUIUsingQuestion(question: Question)
    {
        let type = Int(question.type)
        typeSegControl.selectedSegmentIndex = type
        viewModel?.type = type
        questionView.configureUIUsingQuestion(question)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "showQuestionList" {
            if let listVC = segue.destinationViewController as? QuestionListViewController {
                viewModel?.saveQuestion()
                viewModel?.save()
                listVC.viewModel = QuestionListViewModel(paper: viewModel!.paper!)
                listVC.intentResultDelegate = self
            }
        }
    }
    
}

protocol IntentResultDelegate
{
    func selectQuestionAtIndexPath(indexPath: NSIndexPath)
}

extension PaperViewController: IntentResultDelegate
{
    func selectQuestionAtIndexPath(indexPath: NSIndexPath)
    {
        if let question = viewModel?.loadQuestionAtIndexPath(indexPath) {
            clearScreenContent()                // 清空屏幕
            configureUIUsingQuestion(question)
            scoreTextField.text = String(question.score)
            viewModel?.configureUIUsingQuestion(question)
        }
    }
    
}
