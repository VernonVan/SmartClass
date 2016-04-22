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
        let entity = NSEntityDescription.entityForName("Paper", inManagedObjectContext: self.model)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 10
        
        let sortDescriptor = NSSortDescriptor(key: "isIssued", ascending: false)
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
    
    let fileManager = NSFileManager.defaultManager()
    
    lazy var resourcesName: [String] = {
        var resources = [String]()
        do {
            resources = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.resourceURL.path!)
        } catch let error as NSError {
            print("lazy init resources error! \(error.userInfo)")
        }
        return resources
    }()
    
    lazy var signUpSheetsName: [String] = {
        var signUpSheets = [String]()
        do {
            signUpSheets = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.signUpSheetURL.path!)
        } catch let error as NSError {
            print("lazy init signUpSheets error! \(error.userInfo)")
        }
        return signUpSheets
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
        var count = 0
        if let _ = fetchedResultsController.sections?.count {
            count += 1
        }
        if ConvenientFileManager.hasFilesAtURL(ConvenientFileManager.resourceURL) {
            count += 1
        }
        if ConvenientFileManager.hasFilesAtURL(ConvenientFileManager.signUpSheetURL) {
            count += 1
        }
        return count
    }
    
    func numberOfPapers() -> Int
    {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func numberOfResources() -> Int
    {
        var fileList = [String]()
        do {
            fileList = try fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.resourceURL.path!)
        } catch let error as NSError {
            print("hasFilesAtPath error! \(error.userInfo)")
        }
        return fileList.count
    }
    
    func numberOfSignUpSheet() -> Int
    {
        var fileList = [String]()
        do {
            fileList = try fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.signUpSheetURL.path!)
        } catch let error as NSError {
            print("hasFilesAtPath error! \(error.userInfo)")
        }
        return fileList.count
    }
    
    func paperAtIndexPath(indexPath: NSIndexPath) -> Paper
    {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! Paper
    }
    
    // MARK: Paper cell
    
    func titleForPaperAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        let paper = paperAtIndexPath(indexPath)
        return paper.name
    }
    
    func subtitleForPaperAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        let paper = paperAtIndexPath(indexPath)
        return paper.blurb
    }

    func isIssuedAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        let paper = paperAtIndexPath(indexPath)
        if  paper.isIssued {
            return true
        }
        return false
    }
    
    func deletePaperAtIndexPath(indexPath: NSIndexPath)
    {
        let paper = paperAtIndexPath(indexPath)
        let context = fetchedResultsController.managedObjectContext
        context.deleteObject(paper)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Delete paper error: \(error.userInfo)")
        }
    }
    
    // MARK: Resource cell
    
    func titleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = resourcesName[indexPath.row]
        return title
    }
    
    func subtitleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourcesName[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForResourceAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func isPPTOrUndefineAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        let row = indexPath.row
        if resourcesName[row].containsString(".ppt") || resourcesName[row].containsString(".pptx") {
            return true
        }
        return false
    }
    
    func resourceURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let resourceName = resourcesName[indexPath.row]
        return ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
    }
    
    // MARK: SignUpSheet cell
    
    func titleForSignUpSheetAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = signUpSheetsName[indexPath.row]
        return title
    }
    
    // MARK: - Segue
    func viewModelForNewPaper() -> PaperInformationViewModel
    {
        let paper = NSEntityDescription.insertNewObjectForEntityForName("Paper", inManagedObjectContext: model) as! Paper
        let viewModel = PaperInformationViewModel(paper: paper)
        viewModel.isCreate = true
        return viewModel
    }
    
    func viewModelForExistPaper(indexPath: NSIndexPath) -> PaperInformationViewModel
    {
        let paper = paperAtIndexPath(indexPath)
        let viewModel = PaperInformationViewModel(paper: paper)
        viewModel.isCreate = false
        return viewModel
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        updatedContentSignal.sendNext(nil)
    }
    
    // MARK: - Util
    
    func formatDate(date: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter.stringFromDate(date)
    }
    
}
