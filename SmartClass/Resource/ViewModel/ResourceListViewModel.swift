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
    fileprivate var ppts = [PPT]()
    fileprivate var resources = [Resource]()
    
    fileprivate let fileManager = FileManager.default
    
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
    
    func getAllPPTAtUrl(_ url: URL) -> [PPT]
    {
        let pptFilePath = url.path
        
        var allPPT = [PPT]()
        do {
            let allPPTNames = try self.fileManager.contentsOfDirectory(atPath: pptFilePath).filter({ (fileName) -> Bool in
                let url = ConvenientFileManager.pptURL.appendingPathComponent(fileName)
                return url.pathExtension.contains("ppt")
            })
            for pptName in allPPTNames {
                let createDate = getFileCreateDateAtURL(url.appendingPathComponent(pptName))
                let size = getFileSizeAtURL(url.appendingPathComponent(pptName))
                let ppt = PPT(name: pptName, createDate: createDate, size: size)
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
    
    func pptAtIndexPath(_ indexPath: IndexPath) -> PPT
    {
        return ppts[(indexPath as NSIndexPath).row]
    }

    func pptURLAtIndexPath(_ indexPath: IndexPath) -> URL
    {
        let pptName = ppts[(indexPath as NSIndexPath).row].name
        return ConvenientFileManager.pptURL.appendingPathComponent(pptName!)
    }
    
    func deletePPTAtIndexPath(_ indexPath: IndexPath) -> Bool
    {
        guard let pptName = ppts[(indexPath as NSIndexPath).row].name else {
            return false
        }
        
        let pptUrl = ConvenientFileManager.pptURL.appendingPathComponent(pptName)
        deleteFileAtURL(pptUrl)
        ppts.remove(at: (indexPath as NSIndexPath).row)
        return true
    }
    
    func getAllResourceAtUrl(_ url: URL) -> [Resource]
    {
        let resourceFilePath = url.path
        
        var allResource = [Resource]()
        do {
            let allResourceNames = try self.fileManager.contentsOfDirectory(atPath: resourceFilePath)
            for resourceName in allResourceNames {
                let createDate = getFileCreateDateAtURL(url.appendingPathComponent(resourceName))
                let size = getFileSizeAtURL(url.appendingPathComponent(resourceName))
                let type = getFileTypeAtURL(url.appendingPathComponent(resourceName))
                let resource = Resource(name: resourceName, createDate: createDate, size: size, type: type)
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
    
    func resourceAtIndexPath(_ indexPath: IndexPath) -> Resource
    {
        return resources[(indexPath as NSIndexPath).row]
    }
    
    func resourceURLAtIndexPath(_ indexPath: IndexPath) -> URL
    {
        let resourceName = resources[(indexPath as NSIndexPath).row].name
        return ConvenientFileManager.resourceURL.appendingPathComponent(resourceName!)
    }

    func deleteResourceAtIndexPath(_ indexPath: IndexPath) -> Bool
    {
        guard let resourceName = resources[(indexPath as NSIndexPath).row].name else {
            return false
        }
        
        let resourceUrl = ConvenientFileManager.resourceURL.appendingPathComponent(resourceName)
        deleteFileAtURL(resourceUrl)
        resources.remove(at: (indexPath as NSIndexPath).row)
        return true
    }
    
}

// MARK: - private method

private extension ResourceListViewModel
{
    // 获取fileUrl指向的文件的创建日期
    func getFileCreateDateAtURL(_ fileUrl: URL) -> Date?
    {
        let filePath = fileUrl.path
        
        var createDate: Date? = nil
        do {
            let attrs = try fileManager.attributesOfItem(atPath: filePath)
            createDate = attrs[FileAttributeKey.creationDate] as? Date
        } catch let error as NSError {
            print("ResourceListViewModel getFileCreateDate error: \(error.userInfo)")
        }
        
        return createDate
    }
    
    // 获取fileUrl指向的文件的内存大小
    func getFileSizeAtURL(_ fileUrl: URL) -> String
    {
        let filePath = fileUrl.path

        var fileSize: Double = 0
        
        do {
            let attr: NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary?
            if let _attr = attr {
                fileSize = Double(_attr.fileSize())
            }
        } catch let error as NSError {
            print("ResourceListViewModel getFileSize error: \(error.userInfo)")
        }
        
        return String(format: "%.2f", fileSize / 1024 / 1024) + "M"
    }
    
    // 获取fileUrl指向的文件的类型
    func getFileTypeAtURL(_ fileUrl: URL) -> FileType
    {
        let fileExtension = fileUrl.pathExtension
        switch fileExtension {
        case "pdf":
            return .pdf
        case "docx":
            return .word
        case "xlsx":
            return .excel
        default:
            return .other
        }
    }
    
    // 删除磁盘中url指向的文件
    func deleteFileAtURL(_ url: URL)
    {
        do {
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}
