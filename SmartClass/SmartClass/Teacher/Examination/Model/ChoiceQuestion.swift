//
//  ChoiceQuestion.swift
//  SmartClass
//
//  Created by Vernon on 16/3/4.
//  Copyright © 2016年 Vernon. All rights reserved.
//

class ChoiceQuestion: NSObject
{
    /** 标题*/
    var topic: String?
    /** 选项*/
    var options: [String]?
    /** 分值*/
    var score: Int?
    
}

protocol ChoiceQuestionDelegate
{
    /** 检查题目的完整性*/
    func checkIntegrity() -> Bool
    
    /** 批改题目，返回得分*/
    func markQuestion() -> Int
}
