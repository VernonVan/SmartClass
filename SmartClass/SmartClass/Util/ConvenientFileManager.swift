//
//  ConvenientFileManager.swift
//  SmartClass
//
//  Created by FSQ on 16/4/22.
//  Copyright © 2016年 Vernon. All rights reserved.
//

class ConvenientFileManager: NSObject
{
    static let fileManager = NSFileManager.defaultManager()
    
    static let uploadURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("Upload")
    static let resourceURL = ConvenientFileManager.uploadURL.URLByAppendingPathComponent("Resource")
    
    static let paperURL = ConvenientFileManager.uploadURL.URLByAppendingPathComponent("Paper")
    
    static let signUpSheetURL = ConvenientFileManager.uploadURL.URLByAppendingPathComponent("SignUpSheet")
    
    static func documentURL() -> NSURL
    {
        print("\(NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]).path)")
        return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
    }
    
    static func hasFilesAtURL(url: NSURL) -> Bool
    {
        var isHas = false
        
        if checkIsDirectioyAtPath(url) == true {
            do {
                let fileList =  try fileManager.contentsOfDirectoryAtPath(url.path!)
                isHas = fileList.count > 0
            } catch let error as NSError {
                print("hasFilesAtPath error! \(error.userInfo)")
            }
        }
        
        return isHas
    }
    
    static func checkIsDirectioyAtPath(url: NSURL) -> Bool
    {
        var isDir: ObjCBool = false
        if fileManager.fileExistsAtPath(url.path!, isDirectory: &isDir) {
            if isDir {
                return true
            }
        }
        
        return false
    }
    
    static func createUploadDirectory()
    {
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.resourceURL, withIntermediateDirectories: true, attributes: nil)
            try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.paperURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("createResourceDirectory error: \(error.localizedDescription)")
        }
    }
}
