//
//  PaperListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import ReactiveCocoa
import CoreData

class PaperListViewModel: NSObject
{
    let fileManager = NSFileManager.defaultManager()
    let model: NSManagedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Paper", inManagedObjectContext: self.model)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isIssued", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.model, sectionNameKeyPath: "isIssued", cacheName: nil)
        
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
    }
    
    func modifyPaperListFile()
    {
        let paperListURL = ConvenientFileManager.paperListURL
        let count = numberOfIssuedPapers()
        let paperArray = NSMutableArray()
        
        for index in 0 ..< count {
            let paper = paperAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            let name = paper.name
            let blurb = paper.blurb ?? ""
            let dict = ["name": name!, "blurb": blurb]
            paperArray.addObject(dict)
        }
        
        let outputStream = NSOutputStream(toFileAtPath: paperListURL.path!, append: false)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(paperArray, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        outputStream?.close()
    }
    
    func addExamResultAtIndexPath(indexPath: NSIndexPath, resultDict: NSDictionary)
    {
        if let paperName = resultDict["paper_title"] as? String {
            let studentName = resultDict["student_name"] as? String
            let studentNumber = resultDict["student_number"] as? String
            let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paperName+"_result.plist")
            
            print("addExamResultAtIndexPath")
            
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
    
    func addSignUpRecordWithData(recordDict: NSDictionary)
    {
        if let signUpSheetName = recordDict["date"] as? String {
            let studentName = recordDict["student_name"] as? String
            let studentNumber = recordDict["student_number"] as? String
            let studentListURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("StudentList.plist")
            let signUpSheetURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetName+"签到表.plist")
            do {
                if fileManager.fileExistsAtPath(signUpSheetURL.path!) == false {
                    try fileManager.copyItemAtURL(studentListURL, toURL: signUpSheetURL)
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


// MARK: - TableView

extension PaperListViewModel
{
    func numberOfSections() -> Int
    {
        let count = fetchedResultsController.sections?.count ?? 0
        return count
    }
    
    func numberOfRowsInSection(section: Int) -> Int
    {
        let sectionInfo = fetchedResultsController.sections?[section]
        let count = sectionInfo?.numberOfObjects ?? 0
        return count
    }
    
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
    
    func titleForHeaderInSection(section: Int) -> String
    {
        let sectionInfo = fetchedResultsController.sections?[section]
        if sectionInfo?.name == "0" {
            return NSLocalizedString("编辑中的试卷", comment: "")
        } else {
            return NSLocalizedString("已发布的试卷", comment: "")
        }
    }
    
    func paperAtIndexPath(indexPath: NSIndexPath) -> Paper
    {
        let paper = fetchedResultsController.objectAtIndexPath(indexPath) as? Paper
        return paper!
    }
    
    func isIssuedAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        let paper = paperAtIndexPath(indexPath)
        if  paper.isIssued {
            return true
        }
        return false
    }
    
    func numberOfIssuedPapers() -> Int
    {
        if numberOfSections() > 0 && titleForHeaderInSection(0) == "已发布的试卷" {
            let sectionInfo = fetchedResultsController.sections?[0]
            let issuedPaperNumber = sectionInfo?.numberOfObjects ?? 0
            return issuedPaperNumber
        }
        return 0
    }
    
    func deletePaperAtIndexPath(indexPath: NSIndexPath)
    {
        let paper = paperAtIndexPath(indexPath)
        let context = fetchedResultsController.managedObjectContext
        
        if paperAtIndexPath(indexPath).isIssued {
            let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paper.name!)
            deleteFileAtURL(paperURL)
            let paperResultURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paper.name! + "_result.plist")
            deleteFileAtURL(paperResultURL)
        }
        
        context.deleteObject(paper)
        CoreDataStack.defaultStack.saveContext()
    }
    
    func indexPathForIssuedPaperWithName(paperName: String) -> NSIndexPath?
    {
        var indexPath: NSIndexPath? = nil
        let paperNumber = numberOfRowsInSection(0)
        
        for row in 0 ..< paperNumber {
            indexPath = NSIndexPath(forRow: row, inSection: 0)
            if titleForPaperAtIndexPath(indexPath!) == paperName {
                return indexPath
            }
        }
        return nil
    }
    
}

// MARK: - Segues

extension PaperListViewModel
{
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
    
}

// MARK: private

private extension PaperListViewModel
{
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}


