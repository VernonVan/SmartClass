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
    let fileManager = FileManager.default
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
            try signUpSheetNames = fileManager.contentsOfDirectory(atPath: signUpSheetUrl.path)
            
        } catch let error as NSError {
            print("SignUpSheetListViewModel reloadData error: \(error.localizedDescription)")
        }
    }

    func numberOfSignUpSheet() -> Int
    {
        return signUpSheetNames.count
    }
    
    func titleForSignUpSheetAtIndexPath(_ indexPath: IndexPath) -> String
    {
        let title = signUpSheetNames[(indexPath as NSIndexPath).row]
        return title
    }
    
    func deleteSignUpSheetAtIndexPath(_ indexPath: IndexPath)
    {
        let signUpSheetUrl = ConvenientFileManager.signUpSheetURL.appendingPathComponent(signUpSheetNames[(indexPath as NSIndexPath).row])
        do {
            try fileManager.removeItem(at: signUpSheetUrl)
        } catch let error as NSError {
            print("SignUpSheetListViewModel deleteSignUpSheetAtIndexPath error: \(error.localizedDescription)")
        }
        
        reloadData()
    }
    
}
