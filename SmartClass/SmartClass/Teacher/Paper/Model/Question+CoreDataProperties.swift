//
//  Question+CoreDataProperties.swift
//  SmartClass
//
//  Created by Vernon on 16/4/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var answers: String?
    @NSManaged var choiceA: String?
    @NSManaged var choiceB: String?
    @NSManaged var choiceC: String?
    @NSManaged var choiceD: String?
    @NSManaged var index: Int16
    @NSManaged var score: Int16
    @NSManaged var topic: String?
    @NSManaged var type: Int16
    @NSManaged var paper: Paper?

    var isCompleted: Bool {
        switch type {
        case 0:
            return isCompletedSingleChoice()
        case 1:
            return isCompletedMultipleChoice()
        case 2:
            return isCompletedTrueOrFalse()
        default:
            return false
        }
    }
    
    func isCompletedSingleChoice() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true) && !(choiceC?.isEmpty ?? true) && !(choiceD?.isEmpty ?? true)
        let validAnswer = answers==nil ? false : answers!.characters.count==1
        let validScore = score>0 && score<=100
    //    print("单选：validTopic: \(validTopic), validChoices: \(validChoices), validAnswer: \(validAnswer), validScore: \(validScore)")
        return validTopic && validChoices && validAnswer && validScore
    }
    
    func isCompletedMultipleChoice() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true) && !(choiceC?.isEmpty ?? true) && !(choiceD?.isEmpty ?? true)
        let validAnswers = answers==nil ? false : (answers!.characters.count>1 && answers!.characters.count<=4)
        let validScore = score>0 && score<=100
//        print("answers: \(answers)")
//        print("多选：validTopic: \(validTopic), validChoices: \(validChoices), validAnswers: \(validAnswers), validScore: \(validScore)")
        return validTopic && validChoices && validAnswers && validScore
    }
    
    func isCompletedTrueOrFalse() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true)
        let validAnswer = answers==nil ? false : answers!.characters.count==1
        let validScore = score>0 && score<=100
    //    print("判断：validTopic: \(validTopic), validChoices: \(validChoices), validAnswer: \(validAnswer), validScore: \(validScore)")
        return validTopic && validChoices && validAnswer && validScore
    }
    
    
}
