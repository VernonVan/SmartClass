//
//  StudentViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/4/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift

class StudentInformationViewController: UIViewController
{
    var student: Student?

    var indexPath: IndexPath?
    
    var delegate: StudentInformationDelegate?

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI()
    {
        if let student = student {
            numberTextField.text = student.number
            nameTextField.text = student.name
            majorTextField.text = student.major
            schoolTextField.text = student.school
        }
        
        Observable.combineLatest(numberTextField.rx.textInput.text.asObservable(), nameTextField.rx.textInput.text.asObservable(), majorTextField.rx.textInput.text.asObservable(), schoolTextField.rx.textInput.text.asObservable()) { (number, name, major, school) -> Bool in
                let temp = (number?.length)! > 0 && (name?.length)! > 0
                return temp && major!.length > 0 && school!.length > 0
            }
            .subscribe(onNext: { (enabled) in
                self.doneButton.isEnabled = enabled
                self.doneButton.alpha = (enabled ? 1 : 0.5)
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func doneAction()
    {
        let student = Student(value: ["number": numberTextField.text!, "name": nameTextField.text!, "major": majorTextField.text!, "school": schoolTextField.text!])
        
        if let indexPath = indexPath {
            delegate?.modifyStudentAtIndexPath(indexPath, newStudent: student)
        } else {
            delegate?.addStudent(student)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
