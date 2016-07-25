//
//  QRCodeNavigationController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/21.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QRCodeNavigationController: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationBar.translucent = false
        navigationBar.barTintColor = ThemeGreenColor
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return .Portrait
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return .Portrait
    }
}
