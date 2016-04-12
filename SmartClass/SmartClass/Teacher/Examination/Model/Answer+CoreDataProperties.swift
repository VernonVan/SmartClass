//
//  Answer+CoreDataProperties.swift
//  SmartClass
//
//  Created by Vernon on 16/4/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Answer {

    @NSManaged var answer: String?
    @NSManaged var answerSheet: AnswerSheet?

}
