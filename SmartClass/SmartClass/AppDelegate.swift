//
//  AppDelegate.swift
//  SmartClass
//
//  Created by Vernon on 16/2/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import GCDWebServer
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        
        setInitialViewController()

        ConvenientFileManager.createUploadDirectory()

        print(ConvenientFileManager.uploadURL.path)
        
        let webUploader = GCDWebUploader(uploadDirectory: ConvenientFileManager.uploadURL.path)
        if webUploader.start() == true {
            print("Visit \(webUploader.serverURL)")
        }
        
        return true
    }

    func setInitialViewController()
    {
        let navigationController = window?.rootViewController as!  UINavigationController
        setNavigationBar(navigationController)
        
        let masterViewController = navigationController.viewControllers[0] as! MasterViewController
        let viewModel = MasterViewModel(model: CoreDataStack.defaultStack.managedObjectContext)
        masterViewController.viewModel = viewModel
    }

    func setNavigationBar(navigationController: UINavigationController)
    {
        UIApplication.sharedApplication().statusBarStyle = .LightContent    // 白色状态栏
        
        let bar = navigationController.navigationBar
        bar.barTintColor = ThemeGreenColor         // 修改导航栏的颜色
        bar.tintColor = UIColor.whiteColor()
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]       //修改Title颜色
        bar.translucent = false
    }
    
    

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataStack.defaultStack.saveContext()
    }


}



