//
//  PaperViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/8/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift

class PaperViewController: UIViewController
{

    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var topicView: TopicView!
    @IBOutlet weak var choiceAView: ChoiceView!
    @IBOutlet weak var choiceBView: ChoiceView!
    @IBOutlet weak var choiceCView: ChoiceView!
    @IBOutlet weak var choiceDView: ChoiceView!
    var choiceGroup = ChoiceGroup()
    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var scoreConstraint: NSLayoutConstraint!
    
    var viewModel: PaperViewModel?

    var questionIndex = 0
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        choiceGroup.insertCells([choiceAView, choiceBView, choiceCView, choiceDView])
        
        bindToViewModel()
        
        viewModel?.loadFirstQuestion()
    }
    
    func bindToViewModel()
    {
        typeSegmentControl.rx_value
            .distinctUntilChanged()
            .map { return QuestionType(typeNum: $0)! }
            .subscribeNext { [weak self] (type) in
                self?.changeToQuestionType(type)
            }
            .addDisposableTo(disposeBag)
        
        self.rx_observe(Question.self, "viewModel.currentQuestion")
            .subscribeNext { [weak self] (question) in
                self?.configureUIForQuestion(question)
            }
            .addDisposableTo(disposeBag)
    }

    func changeToQuestionType(type: QuestionType)
    {
        clearUI()

        if type == .TrueOrFalse {
            choiceCView.hidden = true
            choiceDView.hidden = true
            scoreConstraint.priority = 999
        } else {
            choiceCView.hidden = false
            choiceDView.hidden = false
            scoreConstraint.priority = 250
        }
        
        choiceGroup.isMultipleAnswer = (type == .MultipleChoice) ? true : false
    }
    
    // MARK: - Action
    
    @IBAction func selectChoiceAction(gestureRecognizer: UITapGestureRecognizer)
    {
        guard let selectedIndex = gestureRecognizer.view?.tag else {
            return
        }
        choiceGroup.selectCellAtIndex(selectedIndex)
    }

    @IBAction func nextAction()
    {
        let question = currentQuestion()
        viewModel?.saveQuestion(question)
        
        let type = QuestionType(typeNum: typeSegmentControl.selectedSegmentIndex)!
        viewModel?.loadNextQuestionForCurrentIndex(questionIndex, questionType: type)
        questionIndex += 1
    }
    
    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        let question = currentQuestion()
        viewModel?.saveQuestion(question)
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "showQuestionList" {
            if let questionListVC = segue.destinationViewController as? QuestionListViewController {
                let question = currentQuestion()
                viewModel?.saveQuestion(question)
                let questionListViewModel = viewModel?.questionListViewModel()
                questionListVC.viewModel = questionListViewModel
                questionListVC.intentResultDelegate = self
            }
        }
    }
    
    // MARK: - Private
    
    private func configureUIForQuestion(question: Question?)
    {
        guard let question = question else {
            return
        }
        
        clearUI()
        
        typeSegmentControl.selectedSegmentIndex = question.type
        typeSegmentControl.sendActionsForControlEvents(.ValueChanged)
        topicView.configureWithQuestion(question)
        choiceGroup.configureWithQuestion(question)
        scoreView.configureWithQuestion(question)
    }
    
    private func currentQuestion() -> Question
    {
        let question = Question()
        question.index = questionIndex
        question.type = typeSegmentControl.selectedSegmentIndex
        question.topic = topicView.topic
        question.choiceA = choiceAView.choiceText
        question.choiceB = choiceBView.choiceText
        question.choiceC = choiceCView.choiceText
        question.choiceD = choiceDView.choiceText
        question.answers = choiceGroup.answers
        question.score.value = scoreView.score
        return question
    }
    
    private func clearUI()
    {
        topicView.clearContent()
        choiceGroup.clearContents()
        scoreView.clearContent()
    }

}

// MARK: - IntentResultDelegate

extension PaperViewController: IntentResultDelegate
{
    func selectQuestionAtIndex(index: Int)
    {
        questionIndex = index
        viewModel?.loadQuestionAtIndex(index)
    }
}
