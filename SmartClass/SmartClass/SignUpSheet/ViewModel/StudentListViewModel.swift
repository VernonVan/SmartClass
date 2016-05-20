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
    private var students: NSMutableArray?
    
    override init()
    {
        super.init()
    
        students = NSMutableArray(contentsOfURL: defaultStudentListURL)
    }

    func uploadStudentFromFile(name: String) -> Bool
    {
        let fileURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent(name + ".plist")
        if let studentArray = NSArray(contentsOfURL: fileURL) {
            let tempArray = NSMutableArray()
            for (_, dict) in studentArray.enumerate() {
                guard let dict = dict as? NSDictionary, let name = dict["name"] as? String, let number = dict["number"] as? String else {
                    return false
                }
                if let oldIndex = existStudentWithName(name, number: number) {
                    tempArray.addObject(self.students![oldIndex])
                } else {
                    tempArray.addObject(dict)
                }
            }
            
            self.students = tempArray
            return true
        }

        return false
    }
    
    func existStudentWithName(name: String, number: String) -> Int?
    {
        var index: Int? = nil
        for (idx, dict) in self.students!.enumerate() {
            guard let dict = dict as? NSDictionary, let tempName = dict["name"] as? String, let tempNumber = dict["number"] as? String else {
                return nil
            }
            if name == tempName && number == tempNumber {
                index = idx
                return index
            }
        }
        return nil
    }
    
    // MARK: - table view
    
    func numberOfStudents() -> Int
    {
        return students!.count
    }
    
    func nameAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return (students?[indexPath.row] as! NSDictionary).objectForKey("name") as? String
    }
    
    func numberAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return (students?[indexPath.row] as! NSDictionary).objectForKey("number") as? String
    }
    
    func collegeAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return (students?[indexPath.row] as! NSDictionary).objectForKey("college") as? String
    }
    
    func schoolAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        return (students?[indexPath.row] as! NSDictionary).objectForKey("school") as? String
    }
    
    func modifyStudentName(name: String?, number: String?, college: String?, school: String?, atIndexPath indexPath: NSIndexPath)
    {
        let studentDict = students?.objectAtIndex(indexPath.row) as! NSMutableDictionary
        studentDict["name"] = name
        studentDict["number"] = number
        studentDict["college"] = college
        studentDict["school"] = school
    }
    
    func addStudent(name: String?, number: String?, college: String?, school: String?)
    {
        let studentDict = NSMutableDictionary()
        studentDict["name"] = name
        studentDict["number"] = number
        studentDict["college"] = college
        studentDict["school"] = school
        students?.addObject(studentDict)
    }
    
    func deleteStudentAtIndexPath(indexPath: NSIndexPath)
    {
        students?.removeObjectAtIndex(indexPath.row)
    }
    
    func moveStudentFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
    {
        let student = students?.objectAtIndex(fromIndexPath.row)
        students?.removeObjectAtIndex(fromIndexPath.row)
        students?.insertObject(student!, atIndex: toIndexPath.row)
    }
    
    func save()
    {
        students?.writeToURL(defaultStudentListURL, atomically: true)
    }
    
}
