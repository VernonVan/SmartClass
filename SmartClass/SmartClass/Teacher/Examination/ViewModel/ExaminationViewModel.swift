//
//  ExaminationViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ExaminationViewModel: NSObject
{
    // MARK: - variables
    
    var name: String?
    var summary: String?
    var examination: Examination?
    var doneCommand: RACCommand?
    
    
    init(examination: Examination)
    {
        super.init()
        
        self.examination = examination
    }
    
}
