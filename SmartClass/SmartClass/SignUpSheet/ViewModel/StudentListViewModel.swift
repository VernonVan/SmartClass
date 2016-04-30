//
//  StudentListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/4/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class StudentListViewModel: NSObject
{
    private let filePath = ConvenientFileManager.documentURL().URLByAppendingPathComponent("StudentList.plist")
    private var students = [Student]()
    
    override init()
    {
        super.init()
        
        let studentArray = NSArray(contentsOfURL: filePath)
        studentArray?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
            let dict = studentArray![idx] as! NSDictionary
            let name = dict["name"] as! String
            let number = dict["number"] as! String
            let student = Student(name: name, number: number)
            self.students.append(student)
        })
    }

    // MARK: - table view
    
    func numberOfStudents() -> Int
    {
        return students.count
    }
    
    func nameAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return students[indexPath.row].name
    }
    
    func numberAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return students[indexPath.row].number
    }
    
    func modifyStudentName(name: String?, number: String?, atIndexPath indexPath: NSIndexPath)
    {
        var student = students.removeAtIndex(indexPath.row)
        student.name = name
        student.number = number
        students.insert(student, atIndex: indexPath.row)
        
        students.sortInPlace({ $0.number > $1.number })
    }
    
    func addStudent(name: String?, number: String?)
    {
        let student = Student(name: name, number: number)
        students.append(student)
        
        students.sortInPlace({ $0.number < $1.number })
    }
    
    func deleteStudentAtIndexPath(indexPath: NSIndexPath)
    {
        students.removeAtIndex(indexPath.row)
    }
    
    func save()
    {
        let studentArray = NSMutableArray()
        for student in students {
            let dict = NSMutableDictionary()
            dict["name"] = student.name
            dict["number"] = student.number
            studentArray.addObject(dict)
        }
        studentArray.writeToURL(filePath, atomically: false)
    }
    
}
