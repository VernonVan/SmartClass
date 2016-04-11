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
    var questionIndex = -1
    
    // MARK: - initialize
    init(paper: Paper)
    {
        super.init()
        
        self.paper = paper
    }
    
    // MARK: - Core Data
    func saveOneQuestion()
    {
        questionIndex += 1
        
        let question = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: paper!.managedObjectContext!)
        configureQuestionValue(question)
        do {
            try paper?.managedObjectContext?.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
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
    
    func loadQuestionAt(index: Int) -> NSManagedObject
    {
        let question = paper?.questions?.objectAtIndex() as! NSManagedObject
        print(question.valueForKey("topic"))
        return question
    }

}
