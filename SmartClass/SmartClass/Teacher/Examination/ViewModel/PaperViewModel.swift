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
    var score = ""
    var questionIndex = 0
    
    // MARK: - initialize
    init(paper: Paper)
    {
        super.init()
        
        self.paper = paper
    }
    
    // MARK: - Core Data
    func save()
    {
        switch type {
        case .SingleChoice:
            addSingleChoiceQuestion()
        case .MultipleChoice:
            addMultipleChoiceQuestion()
        case .TrueOrFalse:
            addTrueOrFalseQuestion()
        }
    }
    
    func addSingleChoiceQuestion()
    {
        let question = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: paper!.managedObjectContext!) as! Question
        
        question.index = questionIndex
        question.topic = questionViewModel.topic
        question.choiceA = questionViewModel.choiceA
        question.choiceB = questionViewModel.choiceB
        question.choiceC = questionViewModel.choiceC
        question.choiceD = questionViewModel.choiceD
        question.score = Int16(score)!
        
        do {
            try question.managedObjectContext?.save()
        } catch {
            print("save question error")
        }
    }
    
    func addMultipleChoiceQuestion()
    {
        
    }
    
    func addTrueOrFalseQuestion()
    {
        
    }
    
}
