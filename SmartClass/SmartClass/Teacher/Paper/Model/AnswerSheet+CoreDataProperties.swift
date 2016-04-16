//
//  AnswerSheet+CoreDataProperties.swift
//  SmartClass
//
//  Created by Vernon on 16/4/11.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AnswerSheet {

    @NSManaged var isChecked: NSNumber?
    @NSManaged var totalScore: NSNumber?
    @NSManaged var answers: NSManagedObject?
    @NSManaged var examination: Examination?

}
