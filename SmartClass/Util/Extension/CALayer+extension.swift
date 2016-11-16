//
//  CALayer+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/4/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension CALayer
{
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        } get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
    
    var shadowUIColor: UIColor {
        set {
            self.shadowColor = newValue.cgColor
        } get {
            return UIColor(cgColor: self.shadowColor!)
        }
    }
}
