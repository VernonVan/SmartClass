//
//  ExaminationInformationViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ExaminationInformationViewController: UIViewController
{
    // MARK: - outlets
    
    @IBOutlet weak var examinationNameTextField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var examDurationPicker: UIDatePicker!
    @IBOutlet weak var editExamButton: UIButton!
    @IBOutlet weak var startExaminationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - variables
    
    var viewModel: ExaminationViewModel?
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - RAC binding
    
    private func bindViewModel()
    {
        // 初始化界面
        title = viewModel?.name?.length==0 ? NSLocalizedString("试卷信息", comment: "") : viewModel?.name
        examinationNameTextField.text = viewModel?.name
        summaryTextView.text = viewModel?.summary
        examDurationPicker.countDownDuration = viewModel!.duration
        
        examinationNameTextField.rac_textSignal() ~> RAC(viewModel, "name")
        summaryTextView.rac_textSignal() ~> RAC(viewModel, "summary")
        examinationNameTextField.rac_textSignal().map { (temp) -> AnyObject in
            if let text = temp as? String {
                return text.length > 0
            }
            return false
        } ~> RAC(doneButton, "enabled")
        
        doneButton.rac_command = viewModel?.doneCommand
    }
    
    @IBAction func dateChange(sender: UIDatePicker)
    {
        viewModel?.duration = sender.countDownDuration
    }
    
}
