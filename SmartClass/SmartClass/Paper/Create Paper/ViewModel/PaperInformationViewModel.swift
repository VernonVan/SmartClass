//
//  ExaminationViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class PaperInformationViewModel: NSObject
{
    var paper: Paper
    var name = Variable("")
    var blurb = Variable("")
    var isCreate = false

    private let realm = try! Realm()
    
    // MARK: - Init
    
    init(paper: Paper, isCreate: Bool)
    {
        self.paper = paper
        self.name.value = paper.name
        self.blurb.value = paper.blurb
        self.isCreate = isCreate
        
        super.init()
    }

    func save()
    {
        try! realm.write {
            paper.setValue(name.value, forKey: "name")
            paper.setValue(blurb.value, forKey: "blurb")
        }
    }
    
    func cancel()
    {
        try! realm.write {
            realm.delete(paper)
        }
    }
    
    func issuePaper()
    {
        save()
        try! realm.write {
            paper.state = PaperIssueState.issuing.rawValue
        }
        generatePaperJSONFile()
    }
    
    func generatePaperJSONFile()
    {
        let paperDict = NSMutableDictionary(capacity: 10)
        let questions = NSMutableArray()
        
        paperDict["name"] = name.value
        paperDict["blurb"] = blurb.value
        
        for question in paper.questions {
            let questionDict = NSMutableDictionary()
            questionDict["index"] = question.index
            questionDict["type"] = question.type
            questionDict["topic"] = question.topic
            questionDict["A"] = question.choiceA
            questionDict["B"] = question.choiceB
            questionDict["C"] = question.choiceC
            questionDict["D"] = question.choiceD
            questionDict["answer"] = question.answers
            questionDict["score"] = question.score.value
            questions.addObject(questionDict)
        }
        
        paperDict["questions"] = questions
        
        let outputStream = NSOutputStream(toFileAtPath: ConvenientFileManager.paperURL.URLByAppendingPathComponent(name.value).path!, append: false)
        print(ConvenientFileManager.paperURL.URLByAppendingPathComponent(name.value).path!)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(paperDict, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        outputStream?.close()
    }
    
    func isPaperCompleted() -> Bool
    {
        return paper.isCompleted
    }
    
    func paperTotalScore() -> Int
    {
        return paper.totalScore
    }
    
    // MARK: - Segue
    
    func viewModelForPaper() -> PaperViewModel
    {
        let viewModel = PaperViewModel(paper: paper)
        return viewModel
    }
    
}
