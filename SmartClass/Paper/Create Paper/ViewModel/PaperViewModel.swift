//
//  QuestionViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/4/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class PaperViewModel: NSObject
{
    var paper: Paper
    
    dynamic var currentQuestion: Question?

    fileprivate let realm = try! Realm()
    
    // MARK: - initialize
    init(paper: Paper)
    {
        self.paper = paper
        
        super.init()
    }
    
    func loadFirstQuestion()
    {
        if paper.questions.count == 0 {
            let question = Question()
            try! realm.write({
                paper.questions.append(question)
            })
        }
        
        currentQuestion = paper.questions.filter("index = 0").first
    }
    
    func saveQuestion(_ question: Question)
    {
        try! realm.write({
            if let oldQuestion = paper.questions.filter("index = \(question.index)").first {
                realm.delete(oldQuestion)
            }
            paper.questions.append(question)
        })
    }
    
    func loadNextQuestionForCurrentIndex(_ currentIndex: Int, questionType: QuestionType)
    {
        let nextIndex = currentIndex + 1
        if let nextQuestion = paper.questions.filter("index = \(nextIndex)").first {
            currentQuestion = nextQuestion
        } else {
            let nextQuestion = Question()
            try! realm.write({
                nextQuestion.index = nextIndex
                nextQuestion.type = questionType.rawValue
                paper.questions.append(nextQuestion)
            })
            currentQuestion = nextQuestion
        }
    }
    
    func loadQuestionAtIndex(_ index: Int)
    {
        currentQuestion = paper.questions.filter("index = \(index)").first 
    }
    
    func questionListViewModel() -> QuestionListViewModel
    {
        let viewModel = QuestionListViewModel(paper: paper)
        return viewModel
    }
    
}
