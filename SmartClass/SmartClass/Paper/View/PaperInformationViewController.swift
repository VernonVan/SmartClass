//
//  ExaminationInformationViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast
import ReactiveCocoa

class PaperInformationViewController: UIViewController
{
    // MARK: - outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var blurbTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - variables
    
    var viewModel: PaperInformationViewModel?
    
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
    
    @IBAction func issuePaperAction(sender: UIButton)
    {
        let isCompleted = viewModel?.isCompleted()
        let totalScore = viewModel?.totalScore()
        if isCompleted == true {
            if totalScore == 100 {
                viewModel!.issuePaper()
                dismissSelf()
            } else {
                   view.makeToast(NSLocalizedString("试卷总分不是100分！", comment: ""), duration: 0.15, position: nil)
            }
        } else {
             view.makeToast(NSLocalizedString("试卷还未编辑完全！", comment: ""), duration: 0.15, position: nil)
        }
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
