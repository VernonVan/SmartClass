//
//  QuestionListViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/4/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QuestionListViewModel: NSObject
{
    // MARK: - variable
    var paper: Paper?
    
    // MARK: - initialize
    init(paper: Paper)
    {
        super.init()
        
        self.paper = paper
    }
    
    // MARK: - TableView datasource
    
    func numberOfItemsInSection(section: Int) -> Int
    {
        return paper!.questions!.count
    }
    
    func questionAtIndexPath(indexPath: NSIndexPath) -> Question
    {
        return paper?.questions?.objectAtIndex(indexPath.row) as! Question
    }

    func deleteItemAtIndexPath(indexPath: NSIndexPath)
    {
        let mutableQuestions = paper?.questions?.mutableCopy() as? NSMutableOrderedSet
        mutableQuestions?.removeObjectAtIndex(indexPath.row)
        paper?.questions = mutableQuestions?.copy() as? NSOrderedSet
    }
    
    func moveItemFromIndex(fromIndex: Int, toIndex: Int)
    {
        let question = paper?.questions?.objectAtIndex(fromIndex)
        let mutableQuestions = paper?.questions?.mutableCopy() as? NSMutableOrderedSet
        mutableQuestions?.removeObjectAtIndex(fromIndex)
        mutableQuestions?.insertObject(question!, atIndex: toIndex)
        paper?.questions = mutableQuestions?.copy() as? NSOrderedSet
    }
    
}
