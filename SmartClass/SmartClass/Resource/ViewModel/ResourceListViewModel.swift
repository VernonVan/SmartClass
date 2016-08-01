//
//  ResourceListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ResourceListViewModel: NSObject
{
    private var ppts = [PPT]()
    private var resources = [Resource]()
    
    private let fileManager = NSFileManager.defaultManager()
    
    override init()
    {
        super.init()
        
        reloadData()
    }
    
    func reloadData()
    {
        ppts = getAllPPTAtUrl(ConvenientFileManager.pptURL)
        resources = getAllResourceAtUrl(ConvenientFileManager.resourceURL)
    }
    
    func getAllPPTAtUrl(url: NSURL) -> [PPT]
    {
        guard let pptFilePath = url.path else {
            return [PPT]()
        }
        
        var allPPT = [PPT]()
        do {
            let allPPTNames = try self.fileManager.contentsOfDirectoryAtPath(pptFilePath).filter({ (fileName) -> Bool in
                let url = ConvenientFileManager.pptURL.URLByAppendingPathComponent(fileName)
                return url.pathExtension?.containsString("pptx") ?? false
            })
            for pptName in allPPTNames {
                let createDate = getFileCreateDateAtURL(url.URLByAppendingPathComponent(pptName))
                let pptUrl = ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
                let pptView = PPTView(frame: CGRect(x: 0, y: 0, width: 100, height: 75), pptURL: pptUrl)
                pptView.scalesPageToFit = true
                let ppt = PPT(name: pptName, coverImage: pptView, createDate: createDate)
                allPPT.append(ppt)
            }
        } catch let error as NSError {
            print("ResourceListViewModel getAllPPTAtUrl error! \(error.userInfo)")
        }
        
        return allPPT
    }
    
    func numberOfPPT() -> Int
    {
        return ppts.count
    }
    
    func pptAtIndexPath(indexPath: NSIndexPath) -> PPT
    {
        return ppts[indexPath.row]
    }

    func pptURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let pptName = ppts[indexPath.row].name
        return ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName!)
    }
    
    func deletePPTAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        guard let pptName = ppts[indexPath.row].name else {
            return false
        }
        
        let pptUrl = ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
        deleteFileAtURL(pptUrl)
        ppts.removeAtIndex(indexPath.row)
        return true
    }
    
    func getAllResourceAtUrl(url: NSURL) -> [Resource]
    {
        guard let resourceFilePath = url.path else {
            return [Resource]()
        }
        
        var allResource = [Resource]()
        do {
            let allResourceNames = try self.fileManager.contentsOfDirectoryAtPath(resourceFilePath)
            for resourceName in allResourceNames {
                let createDate = getFileCreateDateAtURL(url.URLByAppendingPathComponent(resourceName))
                let resource = Resource(name: resourceName, createDate: createDate)
                allResource.append(resource)
            }
        } catch let error as NSError {
            print("ResourceListViewModel getAllResourceAtUrl error! \(error.userInfo)")
        }
        
        return allResource
    }
    
    func numberOfResource() -> Int
    {
        return resources.count
    }
    
    func resourceAtIndexPath(indexPath: NSIndexPath) -> Resource
    {
        return resources[indexPath.row]
    }
    
    func resourceURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let resourceName = resources[indexPath.row].name
        return ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName!)
    }

    func deleteResourceAtIndexPath(indexPath: NSIndexPath) -> Bool
    {
        guard let resourceName = resources[indexPath.row].name else {
            return false
        }
        
        let resourceUrl = ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
        deleteFileAtURL(resourceUrl)
        resources.removeAtIndex(indexPath.row)
        return true
    }
    
}

// MARK: - private method

private extension ResourceListViewModel
{
    // 获取fileUrl指向的文件的创建日期
    func getFileCreateDateAtURL(fileUrl: NSURL) -> NSDate?
    {
        guard let filePath = fileUrl.path else {
            return nil
        }
        
        var createDate: NSDate? = nil
        do {
            let attrs = try fileManager.attributesOfItemAtPath(filePath)
            createDate = attrs["NSFileCreationDate"] as? NSDate
        } catch let error as NSError {
            print("ResourceListViewModel getFileCreateDate error: \(error.userInfo)")
        }
        
        return createDate
    }
    
    // 删除磁盘中url指向的文件
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}
