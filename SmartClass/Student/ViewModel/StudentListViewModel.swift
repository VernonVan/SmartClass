//
//  StudentListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/4/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class StudentListViewModel: NSObject
{
    fileprivate var students: Results<Student>
    
    fileprivate let realm = try! Realm()
    
    override init()
    {
        students = realm.objects(Student.self).sorted(byProperty: "number")
        
        super.init()
    }
    
    // MARK: - table view
    
    func numberOfStudents() -> Int
    {
        return students.count
    }
    
    func nameAtIndexPath(_ indexPath: IndexPath) -> String
    {
        return students[(indexPath as NSIndexPath).row].name
    }
    
    func numberAtIndexPath(_ indexPath: IndexPath) -> String
    {
        return students[(indexPath as NSIndexPath).row].number
    }
    
    func majorAtIndexPath(_ indexPath: IndexPath) -> String
    {
        return students[(indexPath as NSIndexPath).row].major!
    }
    
    func schoolAtIndexPath(_ indexPath: IndexPath) -> String
    {
        return students[(indexPath as NSIndexPath).row].school!
    }
    
    func studentAtIndexPath(_ indexPath: IndexPath) -> Student
    {
        return students[(indexPath as NSIndexPath).row]
    }
    
    func modifyStudentAtIndexPath(_ indexPath: IndexPath, newStudent student: Student) -> Bool
    {
        if realm.objects(Student.self).filter("number = '\(student.number)'").count == 0 {
            try! realm.write({
                let oldStudent = students[(indexPath as NSIndexPath).row]
                realm.delete(oldStudent)
                realm.add(student)
            })
        } else {
            return false
        }
        
        students = realm.objects(Student.self).sorted(byProperty: "number")
        
        return true
    }
    
    func addStudent(_ student: Student) -> Bool
    {
        if realm.objects(Student.self).filter("number = '\(student.number)'").count == 0 {
            try! realm.write({
                realm.add(student)
            })
        } else {
            return false
        }
        
        students = realm.objects(Student.self).sorted(byProperty: "number")
        
        return true
    }
    
    func deleteStudentAtIndexPath(_ indexPath: IndexPath)
    {
        try! realm.write({
            realm.delete(students[(indexPath as NSIndexPath).row])
        })
        students = realm.objects(Student.self).sorted(byProperty: "number")
    }
}
