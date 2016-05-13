//
//  StudentViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/4/26.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa

class StudentViewController: UIViewController
{
    var name: String?
    var number: String?
    var college: String?
    var school: String?
    var indexPath: NSIndexPath?
    
    var delegate: StudentInformationDelegate?

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        numberTextField.text = number
        nameTextField.text = name
        collegeTextField.text = college
        schoolTextField.text = school
        
        racBinding()
    }
    
    // MARK: - RAC binding
    
    func racBinding()
    {
        nameTextField.rac_textSignal() ~> RAC(self, "name")
        numberTextField.rac_textSignal() ~> RAC(self, "number")
        collegeTextField.rac_textSignal() ~> RAC(self, "college")
        schoolTextField.rac_textSignal() ~> RAC(self, "school")
        
        let validNumberSignal = numberTextField.rac_textSignal().map({ (number) -> AnyObject! in
            return (number as! String).length > 0
        })
        let validNameSignal = nameTextField.rac_textSignal().map({ (name) -> AnyObject! in
            return (name as! String).length > 0
        })
        
        RACSignal.combineLatest([validNumberSignal, validNameSignal]) .map {
            let tuple = $0 as! RACTuple
            let validNumber = tuple.first as! Bool
            let validName = tuple.second as! Bool
            return validName && validNumber
        } ~> RAC(doneButton, "enabled")
    }
    
    // MARK: - Actions

    @IBAction func doneAction(sender: UIBarButtonItem)
    {
        if let indexPath = indexPath {
            delegate?.modifyStudentName(name, number: number, college: college, school: school, atIndexPath: indexPath)
        } else {
            delegate?.addStudentName(name, number: number, college: college, school: school)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func cancelAction(sender: UIBarButtonItem)
    {
        navigationController?.popViewControllerAnimated(true)
    }

}
