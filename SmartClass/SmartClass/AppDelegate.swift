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
    
    var reach: Reachability?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        UITabBar.appearance().tintColor = ThemeGreenColor
        UIApplication.sharedApplication().idleTimerDisabled = true
        IQKeyboardManager.sharedManager().enable = true
        
        ConvenientFileManager.createInitDirectory()
        setViewModels()

        webUploader.start()
        
        // 监控网络状态的变化
        reach = Reachability.reachabilityForInternetConnection()
        reach?.reachableOnWWAN = false
        reach?.startNotifier()

        return true
    }

    func setViewModels()
    {
        let tabBarController = window?.rootViewController as!  UITabBarController
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        let paperListVC = navigationController.viewControllers[0] as! PaperListViewController
        let paperListViewModel = PaperListViewModel(model: CoreDataStack.defaultStack.managedObjectContext)
        paperListVC.viewModel = paperListViewModel
        
        let navigationController2 = tabBarController.viewControllers![2] as! UINavigationController
        let signUpSheetListVC = navigationController2.viewControllers[0] as! SignUpSheetListViewController
        let signUpSheetListViewModel = SignUpSheetListViewModel()
        signUpSheetListVC.viewModel = signUpSheetListViewModel
    }

    func applicationWillTerminate(application: UIApplication)
    {
        CoreDataStack.defaultStack.saveContext()
        reach?.stopNotifier()
    }

    
}




