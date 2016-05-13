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
    let fileManager = NSFileManager.defaultManager()
    
    var pptNames = [String]()
    var resourceNames = [String]()
    
    override init()
    {
        super.init()
        
        reloadData()
    }
    
    func reloadData()
    {
        do {
            pptNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.pptURL.path!)
            resourceNames = try self.fileManager.contentsOfDirectoryAtPath(ConvenientFileManager.resourceURL.path!)
        } catch let error as NSError {
            print("ResourceListViewModel reloadData error! \(error.userInfo)")
        }
        
    }
    
    // MARK: - TableView
    func numberOfRowsInSection(section: Int) -> Int
    {
        let section = ResourceListVCSection(rawValue: section)!
        switch section
        {
        case .PPTSection:
            return numberOfPPT()
        case .ResourceSection:
            return numberOfResource()
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String?
    {
        let section = ResourceListVCSection(rawValue: section)!
        switch section
        {
        case .PPTSection:
            return pptHeaderTitle()
        case .ResourceSection:
            return resourceHeaderTitle()
        }
    }

}

// MARK: - PPT
extension ResourceListViewModel
{
    func titleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = pptNames[indexPath.row]
        return title
    }
    
    func subtitleForPPTAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptNames[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForPPTAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func pptHeaderTitle() -> String?
    {
        let number = numberOfPPT()
        return number != 0 ? NSLocalizedString("幻灯片", comment: "") : nil
    }
    
    func numberOfPPT() -> Int
    {
        return pptNames.count
    }
    
    func pptURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let pptName = pptNames[indexPath.row]
        return ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
    }
    
    func deletePPTAtIndexPath(indexPath: NSIndexPath)
    {
        let pptName = pptNames[indexPath.row]
        pptNames.removeAtIndex(indexPath.row)
        let pptURL = ConvenientFileManager.pptURL.URLByAppendingPathComponent(pptName)
        deleteFileAtURL(pptURL)
    }
    
}

// MARK: Resource
extension ResourceListViewModel
{
    func titleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        let title = resourceNames[indexPath.row]
        return title
    }
    
    func subtitleForResourceAtIndexPath(indexPath: NSIndexPath) -> String
    {
        var subtitle: String = ""
        do {
            let attrs = try fileManager.attributesOfItemAtPath(ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceNames[indexPath.row]).path!)
            let creationDate = attrs["NSFileCreationDate"] as! NSDate
            subtitle = formatDate(creationDate)
        } catch let error as NSError {
            print("subtitleForResourceAtIndexPath error: \(error.userInfo)")
        }
        
        return subtitle
    }
    
    func resourceHeaderTitle() -> String?
    {
        let number = numberOfResource()
        return number != 0 ? NSLocalizedString("资源", comment: "") : nil
    }
    
    func numberOfResource() -> Int
    {
        return resourceNames.count
    }
    
    func resourceURLAtIndexPath(indexPath: NSIndexPath) -> NSURL
    {
        let resourceName = resourceNames[indexPath.row]
        return ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
    }
    
    func deleteResourceAtIndexPath(indexPath: NSIndexPath)
    {
        let resourceName = resourceNames[indexPath.row]
        resourceNames.removeAtIndex(indexPath.row)
        let resourceURL = ConvenientFileManager.resourceURL.URLByAppendingPathComponent(resourceName)
        deleteFileAtURL(resourceURL)
    }
    
}

// MARK: private
private extension ResourceListViewModel
{
    func formatDate(date: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter.stringFromDate(date)
    }
    
    func deleteFileAtURL(url: NSURL)
    {
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
    
}
