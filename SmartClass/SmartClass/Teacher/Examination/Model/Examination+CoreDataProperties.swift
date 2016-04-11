//
//  Examination+CoreDataProperties.swift
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

extension Examination {

    @NSManaged var blurb: String?
    @NSManaged var isFinished: NSNumber?
    @NSManaged var name: String?
    @NSManaged var paper: Paper?
    @NSManaged var studentAnswerSheets: NSSet?
    @NSManaged var teacherAnswerSheet: AnswerSheet?

}
