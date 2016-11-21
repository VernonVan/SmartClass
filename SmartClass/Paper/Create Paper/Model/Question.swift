//
//  Question.swift
//  SmartClass
//
//  Created by Vernon on 16/8/4.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import RealmSwift

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class Question: Object
{
    /// 题目序号
    dynamic var index = 0
    /// 题目类型 （0--单选题 1--多选题 2--判断题）
    dynamic var type = 0
    /// 题目描述
    dynamic var topic: String?
    /// 选项A
    dynamic var choiceA: String?
    /// 选项B
    dynamic var choiceB: String?
    /// 选项C
    dynamic var choiceC: String?
    /// 选项D
    dynamic var choiceD: String?
    /// 答案
    dynamic var answers: String?
    /// 分值
    let score = RealmOptional<Int>()
    /// 所属的试卷
//    let paper = LinkingObjects(fromType: Paper.self, property: "questions")
    
    /// Transient：题目是否完成的标记
    var isCompleted: Bool {
        switch type {
        case 0:
            return isCompletedSingleChoice()
        case 1:
            return isCompletedMultipleChoice()
        case 2:
            return isCompletedTrueOrFalse()
        default:
            return false
        }
    }
    
    func isCompletedSingleChoice() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true) && !(choiceC?.isEmpty ?? true) && !(choiceD?.isEmpty ?? true)
        let validAnswer = answers==nil ? false : answers!.characters.count==1
        let validScore = score.value>0 && score.value<=100
        return validTopic && validChoices && validAnswer && validScore
    }
    
    func isCompletedMultipleChoice() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true) && !(choiceC?.isEmpty ?? true) && !(choiceD?.isEmpty ?? true)
        let validAnswers = answers==nil ? false : (answers!.characters.count>1 && answers!.characters.count<=4)
        let validScore = score.value>0 && score.value<=100
        return validTopic && validChoices && validAnswers && validScore
    }
    
    func isCompletedTrueOrFalse() -> Bool
    {
        let validTopic = !(topic?.isEmpty ?? true)
        let validChoices = !(choiceA?.isEmpty ?? true) && !(choiceB?.isEmpty ?? true)
        let validAnswer = answers==nil ? false : answers!.characters.count==1
        let validScore = score.value>0 && score.value<=100
        return validTopic && validChoices && validAnswer && validScore
    }
    
}

enum QuestionType: Int, CustomStringConvertible
{
    /// 单选题
    case singleChoice = 0
    /// 多选题
    case multipleChoice = 1
    /// 判断题
    case trueOrFalse = 2
    
    init?(typeNum: Int)
    {
        switch typeNum {
        case 0:
            self = .singleChoice
        case 1:
            self = .multipleChoice
        case 2:
            self = .trueOrFalse
        default:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .singleChoice:
            return NSLocalizedString("单选题", comment: "")
        case .multipleChoice:
            return NSLocalizedString("多选题", comment: "")
        case .trueOrFalse:
            return NSLocalizedString("判断题", comment: "")
        }
    }
}
