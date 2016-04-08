//
//  CoreDataStack.swift
//  SmartClass
//
//  Created by Vernon on 16/4/5.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack
{
    // MARK: - 
    static let defaultStack = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SmartClass.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
//    func ensureInitialLoad()
//    {
//        let initialLoadKey = "Initial Load"
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        
//        let hasInitialLoad = userDefaults.boolForKey(initialLoadKey)
//        if hasInitialLoad == false {
//            print("ensureInitialLoad")
//            userDefaults.setBool(true, forKey: initialLoadKey)
//            
//            let exam = NSEntityDescription.insertNewObjectForEntityForName("Examination", inManagedObjectContext: CoreDataStack.defaultStack.managedObjectContext) as! Examination
//            exam.name = "第一次月考"
//            exam.blurb = "呵呵😄"
//            
//        }
//        
//        CoreDataStack.defaultStack.saveContext()
//
//    }
    
}
