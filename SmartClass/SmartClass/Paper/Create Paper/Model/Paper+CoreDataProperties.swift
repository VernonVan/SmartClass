//
//  Paper+CoreDataProperties.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

enum PaperIssueState: Int16, CustomStringConvertible
{
    /// 编辑中
    case editing = 0
    /// 发布中
    case issuing
    /// 已完成
    case finished
    
    var description: String {
        switch self {
        case .editing:
            return NSLocalizedString("试卷编辑中", comment: "")
        case .issuing:
            return NSLocalizedString("试卷发布中", comment: "")
        case .finished:
            return NSLocalizedString("考试已完成", comment: "")
        }
    }
}

extension Paper
{
    /// 试卷名
    @NSManaged var name: String?
    /// 试卷简介
    @NSManaged var blurb: String?
    /// 发布与否
    @NSManaged var issueState: Int16
    /// 题目集合
    @NSManaged var questions: NSOrderedSet?

    /// Transient：试卷是否已经完成（成立条件为试卷中的每个问题都已经完成）
    var isCompleted: Bool {
        var isCompleted = true
        questions?.enumerateObjectsUsingBlock({ (elem, idx, stop) in
            let question = elem as! Question
            if question.isCompleted == false {
                isCompleted = false
            }
        })
        
        return isCompleted
    }
    
    /// Transient：试卷的总分值（试卷的每个问题的分值总和）
    var totalScore: Int16 {
        var totalScore: Int16 = 0
        questions?.enumerateObjectsUsingBlock({ (elem, idx, stop) in
            let question = elem as! Question
            totalScore += question.score
        })
        
        return totalScore
    }
    
}
