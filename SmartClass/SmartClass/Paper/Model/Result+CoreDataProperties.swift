//
//  Result+CoreDataProperties.swift
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

extension Result
{

    @NSManaged var score: Int16
    @NSManaged var number: String?
    @NSManaged var name: String?
    @NSManaged var paper: Paper?

}
