//
//  TeacherMainInterfaceViewModel.swift
//  SmartClass
//
//  Created by Vernon on 16/3/8.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class TeacherMainInterfaceViewModel: NSObject
{
    var exams: [Examination]?
    
    override init()
    {
        super.init()
    }
    
    func numberOfItems() -> Int
    {
        return exams==nil ? 0 : exams!.count
    }
    
    func editViewModelForNewExam() -> ExaminationViewModel
    {
        let exam = Examination()
        let viewModel = ExaminationViewModel(examination: exam)
        return viewModel
    }
}
