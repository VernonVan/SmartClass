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
    
    let webUploader = GCDWebUploader(uploadDirectory: ConvenientFileManager.uploadURL.path)
    lazy var webUploaderURL: String = {
        return "\(self.webUploader.serverURL)"
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        
        setViewModels()

        UITabBar.appearance().tintColor = ThemeGreenColor

        ConvenientFileManager.createInitDirectory()
        print(ConvenientFileManager.uploadURL.path!)

        webUploader.start()
        
        
        
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
    }

    
}




