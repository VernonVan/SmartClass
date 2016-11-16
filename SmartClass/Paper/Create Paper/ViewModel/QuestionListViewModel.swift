//
//  QuestionListViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/4/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionListViewModel: NSObject
{
    var paper: Paper
    
    fileprivate let realm = try! Realm()
    
    init(paper: Paper)
    {
        self.paper = paper
        
        super.init()      
    }
    
    // MARK: - Table view
    
    func numberOfQuestions() -> Int
    {
        return paper.questions.count
    }
    
    func questionAtIndexPath(_ index: Int) -> Question?
    {
        let question = paper.questions.filter("index = \(index)").first
        return question
    }

    func deleteItemAtIndex(_ index: Int)
    {
        try! realm.write({
            if let question = paper.questions.filter("index = \(index)").first {
                realm.delete(question)
            }
            for afterQuestion in paper.questions.filter("index > \(index)") {
                afterQuestion.index -= 1
            }
        })
    }
    
}
