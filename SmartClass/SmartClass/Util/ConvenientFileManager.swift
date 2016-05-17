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
    static let pptURL = ConvenientFileManager.uploadURL.URLByAppendingPathComponent("PPT")
    static let resourceURL = ConvenientFileManager.uploadURL.URLByAppendingPathComponent("Resource")
    static let paperURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("Paper")
    static let paperListURL = paperURL.URLByAppendingPathComponent("PaperList")
    static let studentListURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("StudentList.plist")
    static let signUpSheetURL = ConvenientFileManager.documentURL().URLByAppendingPathComponent("SignUpSheet")
    
    static func documentURL() -> NSURL
    {
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
    
    static func createInitDirectory()
    {
        let firstRun = !ConvenientFileManager.studentListURL.checkResourceIsReachableAndReturnError(nil)
        if firstRun {
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.paperURL, withIntermediateDirectories: true, attributes: nil)
                try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.signUpSheetURL, withIntermediateDirectories: true, attributes: nil)
                try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.resourceURL, withIntermediateDirectories: true, attributes: nil)
                try NSFileManager.defaultManager().createDirectoryAtURL(ConvenientFileManager.pptURL, withIntermediateDirectories: true, attributes: nil)
                let emptyArray = NSArray()
                emptyArray.writeToURL(studentListURL, atomically: true)
            } catch let error as NSError {
                print("createInitDirectory error: \(error.localizedDescription)")
            }
        }
    }
    
}
