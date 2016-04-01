//
//  CALayer+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/4/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

extension CALayer
{
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        } get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
    
    var shadowUIColor: UIColor {
        set {
            self.shadowColor = newValue.CGColor
        } get {
            return UIColor(CGColor: self.shadowColor!)
        }
    }
}
