//
//  TeacherMainInterfaceViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa
import CoreData

class MasterViewModel: RVMViewModel, NSFetchedResultsControllerDelegate
{
    let model: NSManagedObjectContext
    let updatedContentSignal = RACSubject()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Examination", inManagedObjectContext: self.model)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.model, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController.performFetch() Error!")
            abort()
        }
        
        return fetchedResultsController
    }()
    
    init(model: NSManagedObjectContext)
    {
        self.model = model
        super.init()
        
        didBecomeActiveSignal.subscribeNext { [unowned self] x in
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
            }
        }
        
    }
    
    // MARK: - TableView datasource
    
    func numberOfSections() -> Int
    {
        if let count = fetchedResultsController.sections?.count {
            return count
        }
        return 0
    }
    
    func numberOfItemsInSection(section: Int) -> Int
    {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let exam = examAtIndexPath(indexPath)
        return exam.valueForKey("name") as! String
    }
    
    func subtitleAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let exam = examAtIndexPath(indexPath)
        return exam.valueForKey("blurb") as! String
    }
    
    func examAtIndexPath(indexPath: NSIndexPath) -> Examination
    {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! Examination
    }
    
    func isFinishedAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        let exam = examAtIndexPath(indexPath)
        return exam.valueForKey("isFinished") as! Bool
    }
    
    // MARK: - Segue
    func viewModelForNewExam() -> ExamViewModel
    {
        let exam = NSEntityDescription.insertNewObjectForEntityForName("Examination", inManagedObjectContext: model) as! Examination
        let viewModel = ExamViewModel(exam: exam)
        viewModel.isCreate = true
        return viewModel
    }
    
    func viewModelForExistExam(indexPath: NSIndexPath) -> ExamViewModel
    {
        let exam = examAtIndexPath(indexPath)
        let viewModel = ExamViewModel(exam: exam)
        viewModel.isCreate = false
        return viewModel
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        updatedContentSignal.sendNext(nil)
    }
    
}
