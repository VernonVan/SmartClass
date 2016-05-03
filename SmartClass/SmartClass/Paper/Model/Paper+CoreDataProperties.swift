//
//  Paper+CoreDataProperties.swift
//  SmartClass
//
//  Created by Vernon on 16/4/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Paper
{

    @NSManaged var blurb: String?
    @NSManaged var isIssued: Bool
    @NSManaged var name: String?
    @NSManaged var questions: NSOrderedSet?
    @NSManaged var results: NSOrderedSet?

    
    var isCompleted: Bool {
        var isCompleted = true
        questions?.enumerateObjectsUsingBlock({ (elem, idx, stop) in
            let question = elem as! Question
            if question.isCompleted == false {
                isCompleted = false
            }
        })
        
        return isCompleted
    }
    
    var totalScore: Int16 {
        var totalScore: Int16 = 0
        questions?.enumerateObjectsUsingBlock({ (elem, idx, stop) in
            let question = elem as! Question
            totalScore += question.score
        })
        
        return totalScore
    }
}
