//
//  ExaminationViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import CoreData
import ReactiveCocoa

class ExamViewModel: RVMViewModel
{
    // MARK: - variables
    var exam: Examination
    var name: String?
    var blurb: String?
    var isCreate = false
    
    // MARK: - Initialize
    init(exam: Examination)
    {
        self.exam = exam
        super.init()
    
        name = exam.name
        blurb = exam.blurb
        RACObserve(self, keyPath: "name") ~> RAC(exam, "name")
        RACObserve(self, keyPath: "blurb") ~> RAC(exam, "blurb")
    }
    
    func save()
    {
        do {
            try exam.managedObjectContext?.save()
        } catch {
            print("Save examination error!")
        }
    }
    
    func cancel()
    {
        exam.managedObjectContext?.deleteObject(exam)
    }
    
}
