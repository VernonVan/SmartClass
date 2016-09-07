//
//  AppDelegate.swift
//  SmartClass
//
//  Created by Vernon on 16/2/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import GCDWebServer
import Reachability
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    let webUploader = GCDWebUploader(uploadDirectory: ConvenientFileManager.uploadURL.path)
    var webUploaderURL: String {
        return "\(self.webUploader.serverURL)"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        print(ConvenientFileManager.paperURL.path!)
        
        initUI()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        addHandlerForWebUploader()
        webUploader.start()
        
        return true
    }
    
    func initUI()
    {
        UITextView.appearance().tintColor = ThemeGreenColor
        UITextField.appearance().tintColor = ThemeGreenColor
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func addHandlerForWebUploader()
    {
        webUploader.addHandlerForMethod("GET", path: "/getPaperList", requestClass: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse! in
            var json: NSData!
            let papers = NSMutableArray()
            papers.addObject(["name": "小测", "blurb": "呵呵"])
            let dict = ["papers": papers]
            do {
                json = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            } catch let error as NSError {
                print("error: \(error)")
            }
            return GCDWebServerDataResponse(data: json, contentType: "txt")
        }
        
        webUploader.addHandlerForMethod("GET", path: "/confirmID", requestClass: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse! in
            var json: NSData!
            do {
                json = try NSJSONSerialization.dataWithJSONObject(["result", true], options: NSJSONWritingOptions.PrettyPrinted)
            } catch let error as NSError {
                print("error: \(error)")
            }
            return GCDWebServerDataResponse(data: json, contentType: "data")
        }
    }

}




