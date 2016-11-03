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
    
    fileprivate let disposeBag = DisposeBag()
    
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
    }
  
    func bindViewModel()
    {
        nameTextField.rx.text.orEmpty.bindTo(viewModel!.name).addDisposableTo(disposeBag)
        blurbTextView.rx.text.orEmpty.bindTo(viewModel!.blurb).addDisposableTo(disposeBag)
        
        nameTextField.rx.text.map { return ($0?.length)! > 0 }.bindTo(doneButton.rx.enabled).addDisposableTo(disposeBag)
    }
    
    // MARK: - Actions
    
    @IBAction func doneAction(_ sender: UIBarButtonItem)
    {
        viewModel?.save()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem)
    {
        if viewModel?.isCreate == true {
            viewModel?.cancel()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func issuePaperAction()
    {
        let isCompleted = viewModel?.isPaperCompleted()
        let totalScore = viewModel?.paperTotalScore()
        
        if isCompleted == true {
            if totalScore == 100 {
                viewModel?.issuePaper()
                _ = navigationController?.popViewController(animated: true)
            } else {
                view.makeToast(NSLocalizedString("试卷总分不是100分！", comment: ""), duration: 0.15, position: nil)
            }
        } else {
            view.makeToast(NSLocalizedString("试卷还未编辑完全！", comment: ""), duration: 0.15, position: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "editPaper" {
            if let paperVC = segue.destination as? PaperViewController {
                paperVC.viewModel = viewModel?.viewModelForPaper()
            }
        }
    }
    
}
