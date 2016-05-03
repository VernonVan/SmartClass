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
    
    lazy var pptsName: [String] = {
        var ppts = [String]()
        do {
            ppts = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.pptURL.path!)
        } catch let error as NSError {
            print("lazy init ppts error! \(error.userInfo)")
        }
        return ppts
    }()
    
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
    
    // MARK: - TableView
    
    func numberOfSections() -> Int
    {
        var count = 0
        if let _ = fetchedResultsController.sections?.count {
            count += 1
        }
        if ConvenientFileManager.hasFilesAtURL(ConvenientFileManager.pptURL) {
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
    
    func numberOfPPTs() -> Int
    {
        var fileList = [String]()
        do {
            fileList = try fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.pptURL.path!)
        } catch let error as NSError {
            print("numberOfPPTs error! \(error.userInfo)")
        }
        return fileList.count
    }
    
    func numberOfResources() -> Int
    {
        var fileList = [String]()
        do {
            fileList = try fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.resourceURL.path!)
        } catch let error as NSError {
            print("numberOfResources error! \(error.userInfo)")
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
    
    // MARK: Paper
    
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
        
        let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paper.name!)
        deleteFileAtURL(paperURL)
    }
    
    func paperAtIndexPath(indexPath: NSIndexPath) -> Paper
    {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! Paper
    }
    
    func indexPathForPaperWithName(paperName: String) -> NSIndexPath?
    {
        var indexPath: NSIndexPath? = nil
        let paperNumber = numberOfPapers()
        
        for row in 0..<paperNumber {
            indexPath = NSIndexPath(forRow: row, inSection: 0)
            if titleForPaperAtIndexPath(indexPath!) == paperName {
                return indexPath
            }
        }
        
        return nil
    }
    
    func addExamResultAtIndexPath(indexPath: NSIndexPath, resultDict: NSDictionary)
    {
        let paper = paperAtIndexPath(indexPath)
        
        let result = NSEntityDescription.insertNewObjectForEntityForName("Result", inManagedObjectContext: paper.managedObjectContext!) as! Result
        result.name = resultDict["student_name"] as? String
        result.number = resultDict["student_number"] as? String
        result.setValue(resultDict["score"], forKey: "score")
        
        let mutableResults = paper.results?.mutableCopy() as? NSMutableOrderedSet
        mutableResults?.addObject(result)
        paper.results = mutableResults?.copy() as? NSOrderedSet
        
        do {
            try paper.managedObjectContext?.save()
        }  catch let error as NSError {
            print("addExamResultWithData error! \(error.userInfo)")
        }
    }
    
    // MARK: - PPT
    
    func titleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = pptsName[indexPath.row]
        return title
    }
    
    func subtitleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptsName[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForPPTAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func pptURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let pptName = pptsName[indexPath.row]
        return ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
    }
    
    func deletePPTAtIndexPath(indexPath: NSIndexPath)
    {
        let pptName = pptsName[indexPath.row]
        pptsName.removeAtIndex(indexPath.row)
        let pptURL = ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
        deleteFileAtURL(pptURL)
    }
    
    // MARK: Resource
    
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

    func resourceURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let resourceName = resourcesName[indexPath.row]
        return ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
    }
    
    func deleteResourceAtIndexPath(indexPath: NSIndexPath)
    {
        let resourceName = resourcesName[indexPath.row]
        resourcesName.removeAtIndex(indexPath.row)
        let resourceURL = ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
        deleteFileAtURL(resourceURL)
    }
    
    // MARK: SignUpSheet
    
    func titleForSignUpSheetAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = signUpSheetsName[indexPath.row]
        return title
    }
    
    func deleteSignUpSheetAtIndexPath(indexPath: NSIndexPath)
    {
        let signUpSheetName = signUpSheetsName[indexPath.row]
        signUpSheetsName.removeAtIndex(indexPath.row)
        let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName)
        deleteFileAtURL(signUpSheetURL)
    }
    
    func addSignUpRecordWithData(recordDict: NSDictionary)
    {
        if let signUpSheetName = recordDict["date"] as? String {
            let studentName = recordDict["student_name"] as? String
            let studentNumber = recordDict["student_number"] as? String
            let studentListURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("StudentList.plist")
            let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName+".plist")
            do {
                if ConvenientFileManager.fileManager.fileExistsAtPath(signUpSheetURL.path!) == false {
                    try ConvenientFileManager.fileManager.copyItemAtURL(studentListURL, toURL: signUpSheetURL)
                }
            } catch let error as NSError {
                print("addSignUpRecordWithData error: \(error.userInfo)")
            }
            
            
            let studentArray = NSArray(contentsOfURL: signUpSheetURL)
            studentArray?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                let dict = studentArray![idx] as! NSMutableDictionary
                let name = dict["name"] as! String
                let number = dict["number"] as! String
                if name == studentName && number == studentNumber {
                    dict["signed"] = true
                }
            })
            studentArray?.writeToURL(signUpSheetURL, atomically: true)
        }
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
    
    func viewModelForStudentList() -> StudentListViewModel
    {
        return StudentListViewModel()
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
    
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
        
    }
    
}
