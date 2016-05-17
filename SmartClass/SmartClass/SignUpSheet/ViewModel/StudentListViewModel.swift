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
    private let fileURL = ConvenientFileManager.studentListURL
    private var students = [Student]()
    
    override init()
    {
        super.init()
        
        readStudentArrayFromFile()
    }

    func readStudentArrayFromFile()
    {
        students = []
        let studentArray = NSArray(contentsOfURL: fileURL)
        studentArray?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
            let dict = studentArray![idx] as! NSDictionary
            let name = dict["name"] as! String
            let number = dict["number"] as! String
            let college = dict["college"] as? String
            let school = dict["school"] as? String
            let student = Student(name: name, number: number, college: college, school: school)
            self.students.append(student)
        })
        students.sortInPlace({ $0.number < $1.number })
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
    
    func collegeAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return students[indexPath.row].college
    }
    
    func schoolAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return students[indexPath.row].school
    }
    
    func modifyStudentName(name: String?, number: String?, college: String?, school: String?, atIndexPath indexPath: NSIndexPath)
    {
        var student = students.removeAtIndex(indexPath.row)
        student.name = name
        student.number = number
        student.college = college
        student.school = school
        students.insert(student, atIndex: indexPath.row)
        
        students.sortInPlace({ $0.number < $1.number })
    }
    
    func addStudent(name: String?, number: String?, college: String?, school: String?)
    {
        let student = Student(name: name, number: number, college: college, school: school)
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
            dict["college"] = student.college
            dict["school"] = student.school
            studentArray.addObject(dict)
        }
        studentArray.writeToURL(fileURL, atomically: false)
    }
    
}
