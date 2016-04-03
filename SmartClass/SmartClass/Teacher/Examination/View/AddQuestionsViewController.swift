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

class AddQuestionsViewController: UIViewController
{
    // MARK: - variable
    
    private var questionType = QuestionType.SingleChoice
    
    // MARK: - outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionView: QuestionView!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 去除NavigationBar的边界
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.imageWithColor(ThemeGreenColor), forBarPosition: .Any, barMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
        
    }
    
    @IBAction func changeQuestionType(sender: UISegmentedControl)
    {
        questionView.changeQuestionType(QuestionType(rawValue: sender.selectedSegmentIndex)!)
    }
    
}
