//
//  AppDelegate.swift
//  SmartClass
//
//  Created by Vernon on 16/2/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        
        setInitialViewController()
    
        return true
    }

    // 设置初始界面
    func setInitialViewController()
    {
        let navigationController = window?.rootViewController as!  UINavigationController
        setNavigationBar(navigationController)
        
        let masterViewController = navigationController.viewControllers[0] as! MasterViewController
        let viewModel = MasterViewModel(model: CoreDataStack.defaultStack.managedObjectContext)
        masterViewController.viewModel = viewModel
    }
    
    // 设置导航栏
    func setNavigationBar(navigationController: UINavigationController)
    {
        UIApplication.sharedApplication().statusBarStyle = .LightContent    // 白色状态栏
        
        let bar = navigationController.navigationBar
        bar.barTintColor = ThemeGreenColor         // 修改导航栏的颜色
        bar.tintColor = UIColor.whiteColor()
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]       //修改Title颜色
        bar.translucent = false
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataStack.defaultStack.saveContext()
    }


}



