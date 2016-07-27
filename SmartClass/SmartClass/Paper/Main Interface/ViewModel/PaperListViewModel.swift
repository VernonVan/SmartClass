//
//  PaperListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import CoreData
import ReactiveCocoa

class PaperListViewModel: NSObject
{
    let model: NSManagedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let entity = NSEntityDescription.entityForName("Paper", inManagedObjectContext: self.model)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "issueState", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.model, sectionNameKeyPath: "issueState", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController.performFetch() Error!")
            abort()
        }
        
        return fetchedResultsController
    }()
    
    // MARK: - Init
    
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
            let paper = paperAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
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
    
    // 一有学生提交试卷就保存该学生的成绩到student.plist文件中
    func modifyStudentListFileWithData(resultDict: NSDictionary)
    {
        print("----------\(resultDict)")
        guard let paperName = resultDict["paper_title"] as? String, let studentName = resultDict["student_name"] as? String,
            let studentNumber = resultDict["student_number"] as? String//, let signDate = resultDict["date"] as? String 
            else {
            return
        }
        
        let studentListURL = ConvenientFileManager.studentListURL
        if let studentArray = NSArray(contentsOfURL: studentListURL) {
            studentArray.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                if let dict = studentArray[idx] as? NSMutableDictionary {
                    let name = dict["name"] as! String
                    let number = dict["number"] as! String
                    if name == studentName && number == studentNumber {
                        if dict[paperName] == nil {
                            dict[paperName] = resultDict["score"]
//                            dict[signDate] = true
//                            self.addSignUpSheet(signDate)
                            self.modifyPaperResultFile(paperName, studentName: name, correctQuestions: resultDict["correctQuestions"] as! [Int])
                        }
                        stop.memory = true
                    }
                }
            })
            studentArray.writeToURL(studentListURL, atomically: true)
        }
    }
    
    // 一有学生提交试卷就为该学生新增签到记录（自动签到功能）
    func addSignUpSheet(name: String)
    {
        var signUpSheetArray: NSMutableArray
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("signUpSheet") == nil {
            signUpSheetArray = NSMutableArray()
        } else {
            signUpSheetArray = NSMutableArray(array: userDefaults.objectForKey("signUpSheet") as! Array)
        }

        if !signUpSheetArray.containsObject(name) {
            signUpSheetArray.addObject(name)
        }
        userDefaults.setValue(signUpSheetArray, forKey: "signUpSheet")
        userDefaults.synchronize()
    }
    
    // 一有学生提交试卷就保存该学生的每一道题目的正确与否到paperName_result.plist文件中，其中paperName为具体的试卷名
    func modifyPaperResultFile(paperName: String, studentName: String, correctQuestions: [Int])
    {
        let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paperName + "_result.plist")
        if let studentArray = NSMutableArray(contentsOfURL: paperURL) {
            studentArray.addObject(["name": studentName, "correctQuestions": correctQuestions])
            studentArray.writeToURL(paperURL, atomically: true)
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
        let issueState = convertSectionNameToIssueState(sectionInfo?.name)
        
        switch issueState {
        case .Some(.editing):
            return NSLocalizedString("编辑中的试卷", comment: "")
        case .Some(.issuing):
            return NSLocalizedString("发布中的试卷", comment: "")
        case .Some(.finished):
            return NSLocalizedString("已完成的试卷", comment: "")
        default:
            print("数据库出错")
            return NSLocalizedString("数据库出错", comment: "")
        }
    }
    
    func paperAtIndexPath(indexPath: NSIndexPath) -> Paper
    {
        let paper = fetchedResultsController.objectAtIndexPath(indexPath) as? Paper
        return paper!
    }
    
    func issueStateAtIndexPath(indexPath: NSIndexPath) -> PaperIssueState?
    {
        let paper = paperAtIndexPath(indexPath)
        switch paper.issueState {
        case PaperIssueState.editing.rawValue:
            return .editing
        case PaperIssueState.issuing.rawValue:
            return .issuing
        case PaperIssueState.finished.rawValue:
            return .finished
        default:
            return nil
        }
    }
    
    func deletePaperAtIndexPath(indexPath: NSIndexPath)
    {
        let paper = paperAtIndexPath(indexPath)
        let context = fetchedResultsController.managedObjectContext
        
        if paperAtIndexPath(indexPath).issueState == PaperIssueState.issuing.rawValue {
            let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paper.name!)
            deleteFileAtURL(paperURL)
            let paperResultURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent("\(paper.name!)_result.plist")
            deleteFileAtURL(paperResultURL)
        }
        
        context.deleteObject(paper)
        CoreDataStack.defaultStack.saveContext()
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

// MARK: private method

private extension PaperListViewModel
{
    func numberOfIssuedPapers() -> Int
    {
        if numberOfSections() > 1 {
            let sectionInfo = fetchedResultsController.sections?[1]
            print(sectionInfo?.name)
            if convertSectionNameToIssueState(sectionInfo?.name) == .issuing {
                let issuedPaperNumber = sectionInfo?.numberOfObjects ?? 0
                return issuedPaperNumber
            }
        }
        
        return 0
    }
    
    func convertSectionNameToIssueState(sectionName: String?) -> PaperIssueState?
    {
        switch sectionName {
        case .Some("0"):
            return .editing
        case .Some("1"):
            return .issuing
        case .Some("2"):
            return .finished
        default:
            return nil
        }
    }
    
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}


