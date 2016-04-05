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

class TeacherMainInterfaceViewModel: RVMViewModel, NSFetchedResultsControllerDelegate
{
    lazy var updatedContentSignal: RACSubject = {
        let updatedContentSignal = RACSubject()
        return updatedContentSignal
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let model = self.model as! NSManagedObjectContext
        let entity = NSEntityDescription.entityForName("Examination", inManagedObjectContext: model)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: model, sectionNameKeyPath: nil, cacheName: "Master")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController.performFetch() Error!")
            abort()
        }
        
        return fetchedResultsController
    }()
    
    override init(model: AnyObject)
    {
        super.init(model: model)
        
        didBecomeActiveSignal.subscribeNext { (x) in
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
            }
        }
    }
    
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
        let exam =
        return
    }
    
//    -(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
//    ASHRecipe *recipe = [self recipeAtIndexPath:indexPath];
//    return [recipe valueForKey:@keypath(recipe, name)];
//    }
//    
//    -(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath {
//    ASHRecipe *recipe = [self recipeAtIndexPath:indexPath];
//    return [recipe valueForKey:@keypath(recipe, blurb)];
//    }
    
    -(ASHRecipe *)recipeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
}
