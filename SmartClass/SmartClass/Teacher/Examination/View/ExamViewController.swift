//
//  ExaminationInformationViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ExamViewController: UIViewController
{
    // MARK: - outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var blurbTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - variables
    
    var viewModel: ExamViewModel?
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initView()
        
        bindViewModel()
    }
    
    func initView()
    {
        title = viewModel?.name?.length==0 ? NSLocalizedString("试卷信息", comment: "") : viewModel?.name
        nameTextField.text = viewModel?.name
        blurbTextView.text = viewModel?.blurb
    
        if viewModel?.isCreate == false {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        }
    }
    
    // MARK: - RAC binding
    
    func bindViewModel()
    {
        nameTextField.rac_textSignal() ~> RAC(viewModel, "name")
        blurbTextView.rac_textSignal() ~> RAC(viewModel, "blurb")
        
        nameTextField.rac_textSignal().map { (temp) -> AnyObject in
            if let text = temp as? String {
                return text.length > 0
            }
            return false
        } ~> RAC(doneButton, "enabled")
    }
    
    // MARK: - Actions
    @IBAction func doneWasPressed(sender: AnyObject)
    {
        dismissSelf()
    }
    
    @IBAction func cancelWasPressed(sender: AnyObject)
    {
        viewModel!.cancel()
        dismissSelf()
    }
    
    func dismissSelf()
    {
        viewModel?.save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "editPaper" {
            if let paperVC = segue.destinationViewController as? PaperViewController {
                paperVC.viewModel = viewModel?.viewModelForPaper()
            }
        }
    }
    
}
