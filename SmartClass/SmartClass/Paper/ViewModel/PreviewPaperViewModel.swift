//
//  PreviewPaperViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/5/23.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class PreviewPaperViewModel: NSObject
{
    var paper: Paper
    
    // MARK: - Initialize
    init(paper: Paper)
    {
        self.paper = paper
        super.init()
    }
    

}
