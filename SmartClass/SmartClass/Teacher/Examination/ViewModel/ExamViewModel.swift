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
        
        RACTwoWayBinding(self, keyPath1: "name", target2: exam, keyPath2: "name")
        RACTwoWayBinding(self, keyPath1: "blurb", target2: exam, keyPath2: "blurb")
    }

    // MARK: - Core Data
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
    
    // MARK: - Segue
    
    func viewModelForPaper() -> PaperViewModel
    {
        if exam.paper == nil  {
            createPaper()
        }
        let paper = exam.paper!
        let viewModel = PaperViewModel(paper: paper)
        return viewModel
    }
    
    func createPaper()
    {
        let paper = NSEntityDescription.insertNewObjectForEntityForName("Paper", inManagedObjectContext: exam.managedObjectContext!) as! Paper
        exam.paper = paper
    }
    
    // MARK: - RAC extension
    func RACTwoWayBinding(target1: NSObject, keyPath1: String, target2: NSObject, keyPath2: String)
    {
        let channel1 = RACKVOChannel(target: target1, keyPath: keyPath1, nilValue: nil).followingTerminal
        let channel2 = RACKVOChannel(target: target2, keyPath: keyPath2, nilValue: nil).followingTerminal
        channel1.subscribe(channel2)
        channel2.subscribe(channel1)
    }
    
}
