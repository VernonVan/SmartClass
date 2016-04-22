//
//  ExaminationViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import CoreData
import ReactiveCocoa

class PaperInformationViewModel: RVMViewModel
{
    // MARK: - variables
    var paper: Paper
    var name: String?
    var blurb: String?
    var isCreate = false
    
    // MARK: - Initialize
    init(paper: Paper)
    {
        self.paper = paper
        super.init()
        
        RACTwoWayBinding(self, keyPath1: "name", target2: paper, keyPath2: "name")
        RACTwoWayBinding(self, keyPath1: "blurb", target2: paper, keyPath2: "blurb")
    }

    // MARK: - Core Data
    func save()
    {
        do {
            try paper.managedObjectContext?.save()
        } catch {
            print("Save paper error!")
        }
    }
    
    func cancel()
    {
        paper.managedObjectContext?.deleteObject(paper)
    }
    
    func issuePaper()
    {
        paper.isIssued = true
        generatePaperJSONFile()
    }
    
    func generatePaperJSONFile()
    {
        let paperDict = NSMutableDictionary(capacity: 10)
        let singleChoiceQuestions = NSMutableArray()
        let multipleChoiceQuestions = NSMutableArray()
        let trueOrFalseQuestions = NSMutableArray()
        
        paperDict["name"] = name
        paperDict["blurb"] = blurb
    
        for question in paper.questions! {
            let question = question as! Question
            let questionDict = NSMutableDictionary()
            questionDict["index"] = Int(question.index)
            questionDict["topic"] = question.topic
            questionDict["choiceA"] = question.choiceA
            questionDict["choiceB"] = question.choiceB
            questionDict["choiceC"] = question.choiceC
            questionDict["choiceD"] = question.choiceD
            questionDict["answers"] = question.answers
            questionDict["score"] = Int(question.score)
            if question.type == 0 {
                singleChoiceQuestions.addObject(questionDict)
            } else if question.type == 1 {
                multipleChoiceQuestions.addObject(questionDict)
            } else if question.type == 2 {
                trueOrFalseQuestions.addObject(questionDict)
            }
        }
        
        paperDict["singleChoiceQuestions"] = singleChoiceQuestions
        paperDict["multipleChoiceQuestions"] = multipleChoiceQuestions
        paperDict["trueOrFalseQuestions"] = trueOrFalseQuestions
        
        let outputStream = NSOutputStream(toFileAtPath: ConvenientFileManager.paperURL.URLByAppendingPathComponent(name!).path!, append: false)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(paperDict, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        outputStream?.close()
    }
    
    // MARK: - Segue
    
    func viewModelForPaper() -> PaperViewModel
    {
        let viewModel = PaperViewModel(paper: paper)
        return viewModel
    }
    
    func isCompleted() -> Bool
    {
        return paper.isCompleted
    }
    
    func totalScore() -> Int16
    {
        return paper.totalScore
    }
    
    // MARK: - RAC extension
    func RACTwoWayBinding(target1: NSObject, keyPath1: String, target2: NSObject, keyPath2: String)
    {
        let channel1 = RACKVOChannel(target: target1, keyPath: keyPath1, nilValue: nil).followingTerminal
        let channel2 = RACKVOChannel(target: target2, keyPath: keyPath2, nilValue: nil).followingTerminal
        channel1.subscribe(channel2)
        channel2.subscribe(channel1)
    }
    
}
