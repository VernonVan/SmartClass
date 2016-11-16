//
//  Result.swift
//  SmartClass
//
//  Created by Vernon on 16/8/6.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import RealmSwift

class Result: Object
{
    /// 答题者学号
    dynamic var number = "0"
    /// 答题者姓名
    dynamic var name: String?
    /// 分数
    dynamic var score = 0
    /// 正确题数集合
    let correctQuestionNumbers = List<QuestionNumber>()
}

class QuestionNumber: Object
{
    /// 题号
    dynamic var number = 0
}
