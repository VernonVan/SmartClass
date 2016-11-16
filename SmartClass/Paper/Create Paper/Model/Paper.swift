//
//  Paper.swift
//  SmartClass
//
//  Created by Vernon on 16/8/4.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import RealmSwift

class Paper: Object
{
    /// 试卷名
    dynamic var name = ""
    /// 试卷描述
    dynamic var blurb = ""
    /// 试卷状态（0--编辑中 1--发布中 2--已完成）
    dynamic var state = 0
    /// 题目集
    let questions = List<Question>()
    /// 学生考试结果
    let results = List<Result>()
    
    /// Transient：试卷是否已经完成（成立条件为试卷中的每个问题都已经完成）
    var isCompleted: Bool {
        var isCompleted = true
        for question in questions {
            if question.isCompleted == false {
                isCompleted = false
            }
        }
        return isCompleted
    }
    
    /// Transient：试卷的总分值（试卷的每个问题的分值总和）
    var totalScore: Int {
        var totalScore = 0
        for question in questions {
            totalScore += question.score.value ?? 0
        }
        return totalScore
    }
    
}

enum PaperIssueState: Int, CustomStringConvertible
{
    /// 编辑中
    case editing = 0
    /// 发布中
    case issuing = 1
    /// 已完成
    case finished = 2
    
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