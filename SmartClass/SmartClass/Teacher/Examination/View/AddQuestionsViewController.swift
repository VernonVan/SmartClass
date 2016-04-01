//
//  AddQuestionsViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/3/12.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

enum QuestionType: Int {
    case SingleChoice=0, MultipleChoice, TrueOrFalse
}

enum Options: Int {
    case optionA, optionB, optionC, optionD
}

class AddQuestionsViewController: UIViewController
{
    // MARK: - constants
    
    private let VerticalSpace: CGFloat = 8.0
    private let ExtraSpace: CGFloat = 50.0
    private let CellHeight: CGFloat = 40.0
    
    // MARK: - variable
    
    private var questionType = QuestionType.SingleChoice
    private var cellNumber = 4
    
    // MARK: - outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topicTextView: UITextView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 去除NavigationBar的边界
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.imageWithColor(ThemeGreenColor), forBarPosition: .Any, barMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
        
    }
    
}
