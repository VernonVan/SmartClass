//
//  Examination.swift
//  SmartClass
//
//  Created by Vernon on 16/3/11.
//  Copyright © 2016年 Vernon. All rights reserved.
//

class Examination: NSObject
{
    /** 问卷*/
    var questionnair: Questionnair?
    /** 标准答案*/
    var teacherAnswer: AnswerSheet?
    /** 已提交学生的得分*/
    var studentScores: [Float]?
}
