//
//  ConvenientFileManager.swift
//  SmartClass
//
//  Created by FSQ on 16/4/22.
//  Copyright © 2016年 Vernon. All rights reserved.
//

class ConvenientFileManager: NSObject
{
    static let fileManager = FileManager.default
    
    static let paperURL = ConvenientFileManager.documentURL().appendingPathComponent("Paper")
    static let signUpSheetURL = ConvenientFileManager.documentURL().appendingPathComponent("SignUpSheet")
    static let uploadURL = ConvenientFileManager.documentURL().appendingPathComponent("Upload")
    static let pptURL = ConvenientFileManager.uploadURL.appendingPathComponent("PPT")
    static let resourceURL = ConvenientFileManager.uploadURL.appendingPathComponent("Resource")
    
    static func documentURL() -> URL
    {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    }
    
    static func hasFilesAtURL(_ url: URL) -> Bool
    {
        var isHas = false
        
        if checkIsDirectioyAtPath(url) == true {
            do {
                let fileList =  try fileManager.contentsOfDirectory(atPath: url.path)
                isHas = fileList.count > 0
            } catch let error as NSError {
                print("hasFilesAtPath error! \(error.userInfo)")
            }
        }
        
        return isHas
    }
    
    static func checkIsDirectioyAtPath(_ url: URL) -> Bool
    {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return true
            }
        }
        
        return false
    }
    
    static func createInitDirectory()
    {
        // first run
        if !UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            
            do {
                try FileManager.default.createDirectory(at: ConvenientFileManager.paperURL, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: ConvenientFileManager.resourceURL, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: ConvenientFileManager.pptURL, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: ConvenientFileManager.signUpSheetURL, withIntermediateDirectories: true, attributes: nil)
                
                let sourcePath = Bundle.main.path(forResource: "students", ofType: "xlsx")
                let destinationPath = ConvenientFileManager.resourceURL.appendingPathComponent("示例学生名册.xlsx")
                try FileManager.default.moveItem(atPath: sourcePath!, toPath: destinationPath.path)
                
            } catch let error as NSError {
                print("createInitDirectory error: \(error.localizedDescription)")
            }
        }
    }
    
}
