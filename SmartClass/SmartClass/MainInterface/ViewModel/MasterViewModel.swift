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
    let fileManager = NSFileManager.defaultManager()
    
    var pptNames = [String]()
    var resourceNames = [String]()
    var signUpSheetNames = [String]()
    
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

    init(model: NSManagedObjectContext)
    {
        self.model = model
        super.init()
        
        reloadData()
        
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
        return 4
    }
    
    func numberOfRowsInSection(section: Int) -> Int
    {
        let section = MasterViewControllerSection(rawValue: section)!
        switch section
        {
        case .PaperSection:
            return numberOfPaper()
        case .PPTSection:
            return numberOfPPT()
        case .ResourceSection:
            return numberOfResource()
        case .SignSection:
            return numberOfSignUpSheet()
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String?
    {
        let section = MasterViewControllerSection(rawValue: section)!
        switch section
        {
        case .PaperSection:
            return paperHeaderTitle()
        case .PPTSection:
            return pptHeaderTitle()
        case .ResourceSection:
            return resourceHeaderTitle()
        case .SignSection:
            return signUpSheetHeaderTitle()
        }
    }
    
    func reloadData()
    {
        do {
            pptNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.pptURL.path!)
            resourceNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.resourceURL.path!)
            signUpSheetNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.signUpSheetURL.path!)
        } catch let error as NSError {
            print("MasterViewModel reloadData error! \(error.userInfo)")
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        updatedContentSignal.sendNext(nil)
    }

}

// MARK: Paper
extension MasterViewModel
{
 
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
    
    func paperHeaderTitle() -> String?
    {
        let number = numberOfPaper()
        return number != 0 ? NSLocalizedString("试卷", comment: "") : nil
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
        let paperNumber = numberOfPaper()
        
        for row in 0..<paperNumber {
            indexPath = NSIndexPath(forRow: row, inSection: 0)
            if titleForPaperAtIndexPath(indexPath!) == paperName {
                return indexPath
            }
        }
        return nil
    }
    
    func numberOfPaper() -> Int
    {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func addExamResultAtIndexPath(indexPath: NSIndexPath, resultDict: NSDictionary)
    {
        if let paperName = resultDict["paper_title"] as? String {
            let studentName = resultDict["student_name"] as? String
            let studentNumber = resultDict["student_number"] as? String
            let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paperName+"_result.plist")
            
            let studentArray = NSArray(contentsOfURL: paperURL)
            studentArray?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                let dict = studentArray![idx] as! NSMutableDictionary
                let name = dict["name"] as! String
                let number = dict["number"] as! String
                if name == studentName && number == studentNumber {
                    dict["score"] = resultDict["score"]
                }
            })
            
            studentArray?.writeToURL(paperURL, atomically: true)
        }
    }
    
}

// MARK: - PPT
extension MasterViewModel
{
    func titleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = pptNames[indexPath.row]
        return title
    }
    
    func subtitleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptNames[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForPPTAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func pptHeaderTitle() -> String?
    {
        let number = numberOfPPT()
        return number != 0 ? NSLocalizedString("幻灯片", comment: "") : nil
    }
    
    func numberOfPPT() -> Int
    {
        return pptNames.count
    }
    
    func pptURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let pptName = pptNames[indexPath.row]
        return ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
    }
    
    func deletePPTAtIndexPath(indexPath: NSIndexPath)
    {
        let pptName = pptNames[indexPath.row]
        pptNames.removeAtIndex(indexPath.row)
        let pptURL = ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
        deleteFileAtURL(pptURL)
    }
    
}

// MARK: Resource
extension MasterViewModel
{
    func titleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = resourceNames[indexPath.row]
        return title
    }
    
    func subtitleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceNames[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForResourceAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func resourceHeaderTitle() -> String?
    {
        let number = numberOfResource()
        return number != 0 ? NSLocalizedString("资源", comment: "") : nil
    }
    
    func numberOfResource() -> Int
    {
        return resourceNames.count
    }
    
    func resourceURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let resourceName = resourceNames[indexPath.row]
        return ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
    }
    
    func deleteResourceAtIndexPath(indexPath: NSIndexPath)
    {
        let resourceName = resourceNames[indexPath.row]
        resourceNames.removeAtIndex(indexPath.row)
        let resourceURL = ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
        deleteFileAtURL(resourceURL)
    }
    
}

// MARK: SignUpSheet
extension MasterViewModel
{
    func titleForSignUpSheetAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = signUpSheetNames[indexPath.row]
        return title
    }
    
    func signUpSheetHeaderTitle() -> String?
    {
        let number = numberOfSignUpSheet()
        return number != 0 ? NSLocalizedString("签到表", comment: "") : nil
    }
    
    func numberOfSignUpSheet() -> Int
    {
        return signUpSheetNames.count
    }
    
    func deleteSignUpSheetAtIndexPath(indexPath: NSIndexPath)
    {
        let name = signUpSheetNames[indexPath.row]
        signUpSheetNames.removeAtIndex(indexPath.row)
        let url = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(name)
        deleteFileAtURL(url)
    }
    
    func addSignUpRecordWithData(recordDict: NSDictionary)
    {
        if let signUpSheetName = recordDict["date"] as? String {
            let studentName = recordDict["student_name"] as? String
            let studentNumber = recordDict["student_number"] as? String
            let studentListURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("StudentList.plist")
            let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName+".plist")
            do {
                if fileManager.fileExistsAtPath(signUpSheetURL.path!) == false {
                    try fileManager.copyItemAtURL(studentListURL, toURL: signUpSheetURL)
                    signUpSheetNames.append(signUpSheetURL.lastPathComponent!)
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
    
}

// MARK: private
private extension MasterViewModel
{
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
