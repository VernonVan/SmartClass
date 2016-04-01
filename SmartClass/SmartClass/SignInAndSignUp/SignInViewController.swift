//
//  SignInViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/2/29.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Toast

class SignInViewController: UIViewController, SegueHandlerType
{
    // MARK: - outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - constant
    
    enum SegueIdentifier: String {
        case TeacherSegue
        case StudentSegue
    }
    
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
        
        RACSignal
            .combineLatest([usernameTextField.rac_textSignal(), passwordTextField.rac_textSignal()])
            .map({ (temp) -> AnyObject! in
                let tuple = temp as? RACTuple
                return NSNumber(bool: self.validUsername(tuple?.first as? String, andPassword: tuple?.second as? String))    })
            .subscribeNext { (logInActive) -> Void in
                self.signInButton.enabled = (logInActive as? NSNumber)!.boolValue
                self.signInButton.backgroundColor = (logInActive as? NSNumber)!.boolValue ? ThemeGreenColor : ThemeGreyColor    }
        
        signInButton
            .rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .doNext { (x) -> Void in
                self.signInButton.enabled = false
                self.signInButton.backgroundColor = ThemeGreyColor      }
            .subscribeNext { (x) -> Void in
                self.spinner.startAnimating()
                let username = self.usernameTextField.text
                let password = self.passwordTextField.text
                self.logInWithUsername(username!, andPassword: password!)   }
        
    }
    
    // 判断用户名和密码是否有效
    func validUsername(username: String?, andPassword password: String?) -> Bool
    {
        return username?.length>0 && password?.length>0
    }
    
    // 根据用户名和密码跳转到相应界面
    func logInWithUsername(username: String, andPassword password: String)
    {
        BmobUser.loginWithUsernameInBackground(username, password: password) { (bUser, error) -> Void in
            if error != nil {
                self.view.makeToast(NSLocalizedString("用户名或密码错误！", comment: ""))
            } else {
                let identity = bUser.objectForKey("identity") as! String
                if identity == "teacher" {
                    self.performSegueWithIdentifier(.TeacherSegue, sender: nil)
                } else if identity == "student" {
                    self.performSegueWithIdentifier(.StudentSegue, sender: nil)
                }
            }
            
            self.signInButton.enabled = true
            self.signInButton.backgroundColor = ThemeGreenColor
            self.spinner.stopAnimating()
        }
    }
    
    
    
}


