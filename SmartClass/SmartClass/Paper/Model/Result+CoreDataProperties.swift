//
//  Result+CoreDataProperties.swift
//  SmartClass
//
//  Created by FSQ on 16/5/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Result {

    @NSManaged var name: String?
    @NSManaged var number: String?
    @NSManaged var score: Int16
    @NSManaged var paper: Paper?

}
