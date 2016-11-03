//
//  Quiz.swift
//  SmartClass
//
//  Created by Vernon on 16/9/14.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import RealmSwift

class Quiz: Object
{
    /// 提问内容
    dynamic var content: String?
    /// 提问者姓名
    dynamic var name: String?
    /// 提问时间
    dynamic var date: Date?
}
