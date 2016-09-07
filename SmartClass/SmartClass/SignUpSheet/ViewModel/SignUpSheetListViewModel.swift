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
        let signUpSheetUrl = ConvenientFileManager.signUpSheetURL
        do {
            try signUpSheetNames = fileManager.contentsOfDirectoryAtPath(signUpSheetUrl.path!)
            
        } catch let error as NSError {
            print("SignUpSheetListViewModel reloadData error: \(error.localizedDescription)")
        }
    }

    func numberOfSignUpSheet() -> Int
    {
        return signUpSheetNames.count
    }
    
    func titleForSignUpSheetAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = signUpSheetNames[indexPath.row]
        return title
    }
    
    func deleteSignUpSheetAtIndexPath(indexPath: NSIndexPath)
    {
        let signUpSheetUrl = ConvenientFileManager.signUpSheetURL.URLByAppendingPathComponent(signUpSheetNames[indexPath.row])
        do {
            try fileManager.removeItemAtURL(signUpSheetUrl)
        } catch let error as NSError {
            print("SignUpSheetListViewModel deleteSignUpSheetAtIndexPath error: \(error.localizedDescription)")
        }
        
        reloadData()
    }
    
}
