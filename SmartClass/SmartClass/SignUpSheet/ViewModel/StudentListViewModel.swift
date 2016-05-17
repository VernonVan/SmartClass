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
    private let defaultStudentListURL = ConvenientFileManager.studentListURL
    private var students = [Student]()
    
    override init()
    {
        super.init()
        
        uploadStudentFromFile(nil)
    }

    func uploadStudentFromFile(name: String?) -> Bool
    {
        var studentArray: NSArray?
        if name == nil {
            studentArray = NSArray(contentsOfURL: defaultStudentListURL)
        } else {
            let fileURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent(name! + ".plist")
            studentArray = NSArray(contentsOfURL: fileURL)
        }
        
        guard let array = studentArray else {
            return false
        }
        let (students, isSuccessful) = resolveStudentsFromArray(array)
        if isSuccessful {
            self.students = students
            save()
            return true
        }
        return false
    }
    
    func resolveStudentsFromArray(array: NSArray) -> (students: [Student], isSuccessful: Bool)
    {
        var students = [Student]()
        var isSuccessful = true
        array.enumerateObjectsUsingBlock({ (obj, idx, stop) in
            guard let dict = array[idx] as? NSDictionary, let name = dict["name"] as? String, let number = dict["number"] as? String else {
                isSuccessful = false
                let shouldStop: ObjCBool = false
                stop.initialize(shouldStop)
                return
            }
            let college = dict["college"] as? String
            let school = dict["school"] as? String
            let student = Student(name: name, number: number, college: college, school: school)
            students.append(student)
        })
        students.sortInPlace({ $0.number < $1.number })
        
        return (students, isSuccessful)
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
        studentArray.writeToURL(defaultStudentListURL, atomically: false)
    }
    
}
