//
//  Question+CoreDataProperties.swift
//  SmartClass
//
//  Created by Vernon on 16/4/14.
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

}