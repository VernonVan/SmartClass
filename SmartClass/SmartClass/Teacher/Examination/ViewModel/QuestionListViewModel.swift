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
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let question = questionAtIndexPath(indexPath)
        return question.valueForKey("topic") as! String
    }
    
    func accessoryImageNameAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return "finishedQuestion"
    }
    
    func imageNameAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let question = questionAtIndexPath(indexPath)
        let type = question.type
        var imageName = ""
        if type == 0 {
            imageName = "singleChoice"
        } else if type == 1 {
            imageName = "mutipleChoice"
        } else if type == 2 {
            imageName = "trueOrFalse"
        }
        return imageName
    }
    
    func questionAtIndexPath(indexPath: NSIndexPath) -> Question
    {
        return paper?.questions?.objectAtIndex(indexPath.row) as! Question
    }

    func deleteItemAtIndexPath(indexPath: NSIndexPath)
    {

    }
    
}
