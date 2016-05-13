//
//  SignUpSheetListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class SignUpSheetListViewModel: NSObject
{
    let fileManager = NSFileManager.defaultManager()
    var signUpSheetNames = [String]()
    
    override init()
    {
        super.init()
        
        reloadData()
    }
    
    func reloadData()
    {
        do {
            signUpSheetNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.signUpSheetURL.path!)
        } catch let error as NSError {
            print("SignUpSheetListViewModel reloadData error! \(error.userInfo)")
        }
    }
    
    // TableView
    func titleForSignUpSheetAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = signUpSheetNames[indexPath.row]
        return title
    }
    
    func signUpSheetHeaderTitle() -> String?
    {
        let number = numberOfSignUpSheet()
        return number != 0 ? NSLocalizedString("签到表", comment: "") : nil
    }
    
    func numberOfSignUpSheet() -> Int
    {
        return signUpSheetNames.count
    }
    
    func deleteSignUpSheetAtIndexPath(indexPath: NSIndexPath)
    {
        let name = signUpSheetNames[indexPath.row]
        signUpSheetNames.removeAtIndex(indexPath.row)
        let url = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(name)
        deleteFileAtURL(url)
    }
    
    // MARK: - Segue
    
    func viewModelForStudentList() -> StudentListViewModel
    {
        return StudentListViewModel()
    }
    
    func createTempSignUpSheet()
    {
        let studentListURL = ConvenientFileManager.studentListURL
        let tempURL = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent("temp.plist")
        
        do {
            try fileManager.copyItemAtURL(studentListURL, toURL: tempURL)
        } catch let error as NSError {
            print("createTempSignUpSheet error: \(error.userInfo)")
        }
    }
    
}

// MARK: private
private extension SignUpSheetListViewModel
{
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}
