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
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var questionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollViewHeight.constant = nextButton.frame.maxY + 50.0
        
        removeBorderOfNavBar()
        
        bindViewModel()
        
        questionView.viewModel = viewModel?.questionViewModel
        
        print("numberOfQuestion: \(viewModel?.numberOfQuestion())")
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
        RACObserve(self.questionView, keyPath: "viewHeight") ~> RAC(questionViewHeight, "constant")
        
        scoreTextField.rac_textSignal() ~> RAC(viewModel, "score")
        
        RACObserve(viewModel, keyPath: "isEndQuestion").subscribeNext { [unowned self] (isEnd) in
            if let isEnd = isEnd as? Bool {
                self.newButton.hidden = !isEnd
            }
        }
        
        RACObserve(viewModel, keyPath: "questionIndex").subscribeNext { [unowned self] (index) in
            prit(index)
            if let index = index as? Int {
                self.title = "第\(index+1)题"
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changeQuestionType(sender: UISegmentedControl)
    {
        let type = QuestionType(rawValue: sender.selectedSegmentIndex)!
        viewModel!.type = type
        questionView.changeQuestionType(type)
    }
    
    @IBAction func lastAction(sender: UIButton)
    {
        if let question = viewModel!.loadLastQuestion() {
            questionView.loadQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是第一题！", comment: ""), duration: 0.1, position: nil)
        }
    }

    @IBAction func nextAction(sender: UIButton)
    {
        if let question = viewModel!.loadNextQuestion() {
            questionView.loadQuestion(question)
        } else {
            view.makeToast(NSLocalizedString("已经是最后一题！", comment: ""), duration: 0.1, position: nil)
        }
    }
    
    @IBAction func newAction(sender: UIButton)
    {
        if viewModel?.questionViewModel.topic != "" {
            viewModel!.saveQuestion()
            clearScreenContent()
        } else {
            view.makeToast(NSLocalizedString("请先填写问题描述！", comment: ""), duration: 0.1, position: nil)
        }
    }
    
    func clearScreenContent()
    {
        questionView.clearScreenContent()
        scoreTextField.text = ""
    }
    
    
}
