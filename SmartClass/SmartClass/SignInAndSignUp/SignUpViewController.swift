//
//  SignUpViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/2/29.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{
    // MARK: - outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var identitySegment: UISegmentedControl!
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindingUI()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - RAC binding
    
    func bindingUI()
    {
        usernameTextField
            .rac_textSignal()
            .map { (text) -> AnyObject! in
                return text.length>0 ? ThemeGreenColor : UIColor.clearColor()    }
            .subscribeNext { (color) -> Void in
                self.usernameTextField.layer.borderUIColor = color as! UIColor    }
        
        passwordTextField
            .rac_textSignal()
            .map { (text) -> AnyObject! in
                return text.length>0 ? ThemeGreenColor : UIColor.clearColor()    }
            .subscribeNext { (color) -> Void in
                self.passwordTextField.layer.borderUIColor = color as! UIColor     }
    
    }
    
    // MARK: - actions
    @IBAction func selectIdentityAction(sender: UISegmentedControl)
    {
//        let ScreenWidth = UIScreen.mainScreen().bounds.width
//        if sender.selectedSegmentIndex == 0 {
//        //    UIView.animateWithDuration(1, animations: { () -> Void in
//                self.courseNameTextField.frame.origin.x -= 1000
//          //      self.courseNameTextField.alpha = 1
//                //self.signUpButton.frame.origin.y += 38
//         //   })
//        } else {
//        //    UIView.animateWithDuration(1, animations: { () -> Void in
//               // self.courseNameTextField.alpha = 0
//                self.courseNameTextField.frame.origin.x += 1000
//              //  self.signUpButton.frame.origin.y -= 38
//            //})
//        }
    }
    
    @IBAction func confirmRegisterAction(sender: UIButton)
    {
        let bUser = BmobUser()
        bUser.username = usernameTextField.text
        bUser.password = passwordTextField.text
        bUser.setObject("teacher", forKey: "identity")
        bUser.setObject(courseNameTextField.text, forKey: "courseName")
        bUser.signUpInBackgroundWithBlock { (isSuccessful, error) -> Void in
            if isSuccessful {
                print("注册成功")
            } else {
                print("注册失败")
            }
        }
    }
    
}
