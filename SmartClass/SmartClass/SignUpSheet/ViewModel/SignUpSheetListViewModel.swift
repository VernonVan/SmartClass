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
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let signUpSheets = userDefaults.objectForKey("signUpSheet") {
            if let signUpSheetArray = signUpSheets as? [String] {
                self.signUpSheetNames = signUpSheetArray
            }
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
    
    func nameAtIndexPath(indexPath: NSIndexPath) -> String
    {
        return signUpSheetNames[indexPath.row]
    }
    
    func deleteSignUpSheetAtIndexPath(indexPath: NSIndexPath)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        signUpSheetNames.removeAtIndex(indexPath.row)
        userDefaults.setValue(signUpSheetNames, forKey: "signUpSheet")
        userDefaults.synchronize()
    }
    
    // MARK: - Segue
    
    func viewModelForStudentList() -> StudentListViewModel
    {
        return StudentListViewModel()
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
