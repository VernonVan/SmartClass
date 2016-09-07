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
    private var students: Results<Student>
    
    private let realm = try! Realm()
    
    override init()
    {
        students = realm.objects(Student).sorted("number")
        
        super.init()
    }
    
    // MARK: - table view
    
    func numberOfStudents() -> Int
    {
        return students.count
    }
    
    func nameAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return students[indexPath.row].name
    }
    
    func numberAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return students[indexPath.row].number
    }
    
    func majorAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return students[indexPath.row].major!
    }
    
    func schoolAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return students[indexPath.row].school!
    }
    
    func studentAtIndexPath(indexPath: NSIndexPath) -> Student
    {
        return students[indexPath.row]
    }
    
    func modifyStudentAtIndexPath(indexPath: NSIndexPath, newStudent student: Student)
    {
        try! realm.write({
            let oldStudent = students[indexPath.row]
            realm.delete(oldStudent)
            realm.add(student)
        })
        students = realm.objects(Student).sorted("number")
    }
    
    func addStudent(student: Student)
    {
        try! realm.write({
            realm.add(student)
        })
        students = realm.objects(Student).sorted("number")
    }
    
    func deleteStudentAtIndexPath(indexPath: NSIndexPath)
    {
        try! realm.write({
            realm.delete(students[indexPath.row])
        })
        students = realm.objects(Student).sorted("number")
    }
}
