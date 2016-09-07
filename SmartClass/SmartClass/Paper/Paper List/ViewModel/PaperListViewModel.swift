//
//  PaperListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import RxSwift
import RealmSwift

enum PaperType: Int
{
    case Editing = 0
    case Issuing = 1
    case Finished = 2
}

class PaperListViewModel: NSObject
{
    var paperType = PaperType.Editing {
        didSet {
            reloadPaper()
        }
    }
    
    private let realm = try! Realm()
    var showingPapers: Results<(Paper)>!
    
    override init()
    {
        showingPapers = realm.objects(Paper).filter("state = 0")
        super.init()
    }
    
    func reloadPaper()
    {
        switch paperType {
        case .Editing:
            showingPapers = realm.objects(Paper).filter("state = 0")
        case .Issuing:
            showingPapers = realm.objects(Paper).filter("state = 1")
        case .Finished:
            showingPapers = realm.objects(Paper).filter("state = 2")
        }
    }
}


// MARK: - TableView

extension PaperListViewModel
{
    
    func numberOfPapers() -> Int
    {
        let count = showingPapers.count
        return count
    }
    
    func paperAtIndexPath(indexPath: NSIndexPath) -> Paper
    {
        let paper = showingPapers[indexPath.row]
        return paper
    }
    
    func deletePaperAtIndexPath(indexPath: NSIndexPath)
    {
        let paper = paperAtIndexPath(indexPath)
        
        try! realm.write {
            realm.delete(paper)
        }
    }
    
}

// MARK: - Segues

extension PaperListViewModel
{
    func viewModelForNewPaper() -> PaperInformationViewModel
    {
        let paper = Paper()
        try! realm.write {
            realm.add(paper)
        }
        let viewModel = PaperInformationViewModel(paper: paper, isCreate: true)
        return viewModel
    }
    
    func viewModelForExistPaper(indexPath: NSIndexPath) -> PaperInformationViewModel
    {
        let paper = paperAtIndexPath(indexPath)
        let viewModel = PaperInformationViewModel(paper: paper, isCreate: false)
        return viewModel
    }
    
}

// MARK: private method

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
    
    
    
//    func modifyPaperListFile()
//    {
//        let paperListURL = ConvenientFileManager.paperListURL
//        let count = numberOfIssuedPapers()
//        let paperArray = NSMutableArray()
//        
//        for index in 0 ..< count {
//            let paper = paperAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
//            let name = paper.name
//            let blurb = paper.blurb ?? ""
//            let dict = ["name": name, "blurb": blurb]
//            paperArray.addObject(dict)
//        }
//        
//        let outputStream = NSOutputStream(toFileAtPath: paperListURL.path!, append: false)
//        outputStream?.open()
//        NSJSONSerialization.writeJSONObject(paperArray, toStream: outputStream!, options: .PrettyPrinted, error: nil)
//        outputStream?.close()
//    }
//    
//    
//    // 一有学生提交试卷就为该学生新增签到记录（自动签到功能）
//    func addSignUpSheet(name: String)
//    {
//        var signUpSheetArray: NSMutableArray
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        if userDefaults.objectForKey("signUpSheet") == nil {
//            signUpSheetArray = NSMutableArray()
//        } else {
//            signUpSheetArray = NSMutableArray(array: userDefaults.objectForKey("signUpSheet") as! Array)
//        }
//        
//        if !signUpSheetArray.containsObject(name) {
//            signUpSheetArray.addObject(name)
//        }
//        userDefaults.setValue(signUpSheetArray, forKey: "signUpSheet")
//        userDefaults.synchronize()
//    }
//    
//    // 一有学生提交试卷就保存该学生的每一道题目的正确与否到paperName_result.plist文件中，其中paperName为具体的试卷名
//    func modifyPaperResultFile(paperName: String, studentName: String, correctQuestions: [Int])
//    {
//        let paperURL = ConvenientFileManager.paperURL.URLByAppendingPathComponent(paperName + "_result.plist")
//        if let studentArray = NSMutableArray(contentsOfURL: paperURL) {
//            studentArray.addObject(["name": studentName, "correctQuestions": correctQuestions])
//            studentArray.writeToURL(paperURL, atomically: true)
//        }
//    }
    
}


