//
//  NSDate+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/7/29.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension Date
{
    static var today: Date {
        let cal = Calendar.current
        var components = (cal as NSCalendar).components([.hour, .minute, .second], from: Date())
        components.hour = -components.hour!
        components.minute = -components.minute!
        components.second = -components.second!
        let today = (cal as NSCalendar).date(byAdding: components, to: Date(), options: .wrapComponents)
        return today!
    }
    
    static var tomorrow: Date {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = 1
        let tomorrow = (gregorian as NSCalendar?)?.date(byAdding: offsetComponents, to: Date.today, options: .wrapComponents)
        return tomorrow!
    }
    
    static func nextDateAfterDate(_ currentDate: Date) -> Date
    {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = 1
        let nextDate = (gregorian as NSCalendar?)?.date(byAdding: offsetComponents, to: currentDate, options: .wrapComponents)
        return nextDate!
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        return formatter.string(from: self)
    }
    
    var dateWithHourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d HH:mm"
        return formatter.string(from: self)
    }

}
