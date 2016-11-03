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
    
    fileprivate let disposeBag = DisposeBag()
    
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
//        typeSegmentControl.rx.value
//            .map { return QuestionType(typeNum: $0)! }
//            .subscribe { [weak self] (type) in
//                self?.changeToQuestionType(type)
//            }
//            .addDisposableTo(disposeBag)
        
        self.rx.observe(Question.self, "viewModel.currentQuestion")
            .subscribe(onNext: { [weak self] (question) in
                self?.configureUIForQuestion(question)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }

    @IBAction func changeTypeAction(_ segmentControl: UISegmentedControl)
    {
        let type = QuestionType(typeNum: segmentControl.selectedSegmentIndex)!
        changeToQuestionType(type)
    }
    
    
    func changeToQuestionType(_ type: QuestionType)
    {
        clearUI()

        if type == .trueOrFalse {
            choiceCView.isHidden = true
            choiceDView.isHidden = true
            scoreConstraint.priority = 999
        } else {
            choiceCView.isHidden = false
            choiceDView.isHidden = false
            scoreConstraint.priority = 250
        }
        
        choiceGroup.isMultipleAnswer = (type == .multipleChoice) ? true : false
    }
    
    // MARK: - Action
    
    @IBAction func selectChoiceAction(_ gestureRecognizer: UITapGestureRecognizer)
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
    
    @IBAction func doneAction(_ sender: UIBarButtonItem)
    {
        let question = currentQuestion()
        viewModel?.saveQuestion(question)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showQuestionList" {
            if let questionListVC = segue.destination as? QuestionListViewController {
                let question = currentQuestion()
                viewModel?.saveQuestion(question)
                let questionListViewModel = viewModel?.questionListViewModel()
                questionListVC.viewModel = questionListViewModel
                questionListVC.intentResultDelegate = self
            }
        }
    }
    
    // MARK: - Private
    
    fileprivate func configureUIForQuestion(_ question: Question?)
    {
        guard let question = question else {
            return
        }
        
        clearUI()
        
        typeSegmentControl.selectedSegmentIndex = question.type
        typeSegmentControl.sendActions(for: .valueChanged)
        topicView.configureWithQuestion(question)
        choiceGroup.configureWithQuestion(question)
        scoreView.configureWithQuestion(question)
    }
    
    fileprivate func currentQuestion() -> Question
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
    
    fileprivate func clearUI()
    {
        topicView.clearContent()
        choiceGroup.clearContents()
        scoreView.clearContent()
    }

}

// MARK: - IntentResultDelegate

extension PaperViewController: IntentResultDelegate
{
    func selectQuestionAtIndex(_ index: Int)
    {
        questionIndex = index
        viewModel?.loadQuestionAtIndex(index)
    }
}
