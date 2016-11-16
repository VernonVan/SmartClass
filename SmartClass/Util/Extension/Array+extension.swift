//
//  Array+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/9/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension Array where Element: Equatable
{
    mutating func removeObject(_ object : Iterator.Element)
    {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
