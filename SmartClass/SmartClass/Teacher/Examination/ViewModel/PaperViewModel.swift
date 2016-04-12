//
//  QuestionViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/4/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import CoreData

class PaperViewModel: RVMViewModel
{
    // MARK: - variable
    var paper: Paper?
    lazy var questionViewModel: QuestionViewModel = {
        let viewModel = QuestionViewModel()
        return viewModel
    }()
    var type = QuestionType.SingleChoice
    var score = 0
    var questionIndex = 0
    var isEndQuestion: Bool {
        return questionIndex == numberOfQuestion()
    }
    var isFirstQuestion: Bool {
        return questionIndex == 0
    }
    
    // MARK: - initialize
    init(paper: Paper)
    {
        super.init()
        
        self.paper = paper
    }
    
    // MARK: - Core Data
    func saveQuestion()
    {
        let question = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: paper!.managedObjectContext!)
        configureQuestionValue(question)
        
        let questionsMutableOrderedSet = paper?.questions?.mutableCopy() as? NSMutableOrderedSet
        questionsMutableOrderedSet?.addObject(question)
        paper?.questions = questionsMutableOrderedSet?.copy() as? NSOrderedSet
        
        questionIndex += 1
        
        print("save one question")
    }
    
    func configureQuestionValue(question: NSManagedObject)
    {
        question.setValue(questionIndex, forKey: "index")
        question.setValue(String(type) , forKey: "type")
        question.setValue(questionViewModel.topic, forKey: "topic")
        question.setValue(questionViewModel.choiceA, forKey: "choiceA")
        question.setValue(questionViewModel.choiceB, forKey: "choiceB")
        question.setValue(questionViewModel.choiceC, forKey: "choiceC")
        question.setValue(questionViewModel.choiceD, forKey: "choiceD")
        question.setValue(score, forKey: "score")
    }
    
    func questionAtIndex(index: Int) -> Question?
    {
        return paper?.questions![index] as? Question
    }
    
    func numberOfQuestion() -> Int
    {
        if let count = paper?.questions?.count {
            return count
        }
        return 0
    }
    
    func loadLastQuestion() -> Question?
    {
        if isFirstQuestion {
            return nil
        }
        
        questionIndex -= 1
        return paper?.questions?.objectAtIndex(questionIndex) as? Question
    }

    func loadNextQuestion() -> Question?
    {
        if isEndQuestion {
            return nil
        }
        
        questionIndex += 1
        return paper?.questions?.objectAtIndex(questionIndex) as? Question
    }
    
    
    
}
