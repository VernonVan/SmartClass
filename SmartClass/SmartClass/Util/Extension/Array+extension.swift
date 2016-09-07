//
//  Array+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/9/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension Array where Element: Equatable
{
    mutating func removeObject(object : Generator.Element)
    {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}