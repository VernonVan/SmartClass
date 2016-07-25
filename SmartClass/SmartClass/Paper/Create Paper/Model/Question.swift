//
//  Question.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import CoreData

enum QuestionType: Int
{
    /// 单选题
    case SingleChoice = 0
    /// 多选题
    case MultipleChoice
    /// 判断题
    case TrueOrFalse
    
    init?(typeNum: Int16)
    {
        switch typeNum {
        case 0:
            self = .SingleChoice
        case 1:
            self = .MultipleChoice
        case 2:
            self = .TrueOrFalse
        default:
            return nil
        }
    }
}

class Question: NSManagedObject
{
    
}
