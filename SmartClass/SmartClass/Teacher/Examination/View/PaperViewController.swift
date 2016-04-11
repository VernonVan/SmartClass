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
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollViewHeight.constant = nextButton.frame.maxY + 50.0
        
        removeBorderOfNavBar()
        
        bindViewModel()
        
        questionView.viewModel = viewModel?.questionViewModel
        
        viewModel!.loadQuestionAt(0)
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
    }
    
    // MARK: - Actions
    
    @IBAction func changeQuestionType(sender: UISegmentedControl)
    {
        let type = QuestionType(rawValue: sender.selectedSegmentIndex)!
        viewModel!.type = type
        questionView.changeQuestionType(type)
    }

    @IBAction func nextAction(sender: UIButton)
    {
        viewModel!.saveOneQuestion()
        clearScreenContent()
    }
    
    func clearScreenContent()
    {
        scoreTextField.text = nil
        questionView.clearScreenContent()
    }
    
}
