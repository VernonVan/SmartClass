//
//  Character+extension.swift
//  SmartClass
//
//  Created by Vernon on 16/4/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

extension Character
{
    // get ascii from character
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}