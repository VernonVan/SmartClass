//
//  Student.swift
//  SmartClass
//
//  Created by Vernon on 16/8/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object
{
    /// 姓名
    dynamic var name = ""
    /// 学号
    dynamic var number = ""
    /// 专业
    dynamic var major: String?
    /// 学校
    dynamic var school: String?
    
    override static func primaryKey() -> String?
    {
        return "number"
    }
    
    override static func indexedProperties() -> [String]
    {
        return ["number"]
    }
    
}

//extension Student: Equatable {}

func ==(lhs: Student, rhs: Student) -> Bool
{
    return lhs.name == rhs.name && lhs.number == rhs.number && lhs.major == rhs.major && lhs.school == rhs.school
}
