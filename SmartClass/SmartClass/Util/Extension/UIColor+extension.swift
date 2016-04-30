//
//  UIColor+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/4/3.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int)
    {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    var coreImageColor: CoreImage.CIColor?
    {
        return CoreImage.CIColor(color: self)
    }
    
    convenience init(color: UIColor, alpha: CGFloat)
    {
        let ciColor = color.coreImageColor
        self.init(red: ciColor!.red, green: ciColor!.green, blue: ciColor!.blue, alpha: alpha)
    }
}
