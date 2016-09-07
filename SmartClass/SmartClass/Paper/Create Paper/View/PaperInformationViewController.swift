//
//  ExaminationInformationViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/7.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast
import RxSwift
import RxCocoa

class PaperInformationViewController: UIViewController
{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var blurbTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var viewModel: PaperInformationViewModel?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initView()
        
        bindViewModel()
    }
    
    func initView()
    {
        nameTextField.text = viewModel?.name.value
        blurbTextView.text = viewModel?.blurb.value
    
        if viewModel?.isCreate == false {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        }
    }
    
    func bindViewModel()
    {
        nameTextField.rx_text.bindTo(viewModel!.name).addDisposableTo(disposeBag)
        blurbTextView.rx_text.bindTo(viewModel!.blurb).addDisposableTo(disposeBag)
        
        nameTextField.rx_text.map { return $0.length > 0 }.bindTo(doneButton.rx_enabled).addDisposableTo(disposeBag)
    }
    
    // MARK: - Actions
    
    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        viewModel?.save()
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func cancelAction(sender: UIBarButtonItem)
    {
        viewModel?.cancel()
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func issuePaperAction()
    {
        let isCompleted = viewModel?.isPaperCompleted()
        let totalScore = viewModel?.paperTotalScore()
        
        if isCompleted == true {
            if totalScore == 100 {
                viewModel?.issuePaper()
                navigationController?.popViewControllerAnimated(true)
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
