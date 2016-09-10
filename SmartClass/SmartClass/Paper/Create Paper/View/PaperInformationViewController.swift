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
        let customButton = UIButton(type: .Custom)
        customButton.setImage(UIImage(named: "Back"), forState: .Normal)
        customButton.setTitle("试卷列表", forState: .Normal)
        customButton.setTitleColor(ThemeBlueColor, forState: .Normal)
        customButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 4)
        customButton.sizeToFit()
        customButton.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = customBarButtonItem
        
        nameTextField.text = viewModel?.name.value
        blurbTextView.text = viewModel?.blurb.value
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
    
    func backAction()
    {
        if viewModel?.isCreate == true {
            viewModel?.cancel()
        }
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
