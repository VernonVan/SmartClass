//
//  NSDate+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/7/29.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension NSDate
{
    var dateString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter.stringFromDate(self)
    }

}
