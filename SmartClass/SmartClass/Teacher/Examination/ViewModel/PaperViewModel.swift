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
    
    dynamic var questionIndex = 0 {
        didSet {
            isEndQuestion = (questionIndex == numberOfQuestion()-1)
            isFirstQuestion = (questionIndex == 0)
        }
    }
    dynamic var isEndQuestion = true
    var isFirstQuestion = true
    
    var type = QuestionType.SingleChoice.rawValue
    var topic: String?
    var choiceA: String?
    var choiceB: String?
    var choiceC: String?
    var choiceD: String?
    var answers: String?
    var score: Int?

    // MARK: - initialize
    init(paper: Paper)
    {
        super.init()
        
        self.paper = paper
        
        isEndQuestion = questionIndex==numberOfQuestion()-1
    }

    // MARK: - Core Data
    
    func addQuestion()
    {
        let question = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: paper!.managedObjectContext!)
        
        let mutableQuestions = paper?.questions?.mutableCopy() as? NSMutableOrderedSet
        mutableQuestions?.addObject(question)
        paper?.questions = mutableQuestions?.copy() as? NSOrderedSet
    }
    
    func saveQuestion()
    {
        let question = paper?.questions?.objectAtIndex(questionIndex) as! NSManagedObject
        configureQuestionValue(question)
    }
    
    func save()
    {
        do {
            try paper?.managedObjectContext?.save()
        } catch {
            let error = error as NSError
            print("saveQuestion error!\t\(error.userInfo)")
        }
    }
    
    func configureQuestionValue(question: NSManagedObject)
    {
        question.setValue(questionIndex, forKey: "index")
        question.setValue(type , forKey: "type")
        question.setValue(topic, forKey: "topic")
        question.setValue(choiceA, forKey: "choiceA")
        question.setValue(choiceB, forKey: "choiceB")
        question.setValue(choiceC, forKey: "choiceC")
        question.setValue(choiceD, forKey: "choiceD")
        question.setValue(answers, forKey: "answers")
        question.setValue(score, forKey: "score")
    }
    
    func numberOfQuestion() -> Int
    {
        if let count = paper?.questions?.count {
            return count
        }
        return 0
    }

    // MARK: - question
    
    func loadQuestionAtIndexPath(indexPath: NSIndexPath) -> Question?
    {
        if let question = paper?.questions?.objectAtIndex(indexPath.row) as? Question {
            questionIndex = indexPath.row
            return question
        }
        return loadFirstQuestion()
    }
    
    func loadFirstQuestion() -> Question?
    {
        if numberOfQuestion() == 0 {
            addQuestion()
        }
        
        questionIndex = 0
        return paper?.questions?.objectAtIndex(questionIndex) as? Question
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
    
    func configureUIUsingQuestion(question: Question)
    {
        type = Int(question.type)
        topic = question.topic
        choiceA = question.choiceA
        choiceB = question.choiceB
        choiceC = question.choiceC
        choiceD = question.choiceD
        answers = question.answers
        score = Int(question.score)
    }
    
}
