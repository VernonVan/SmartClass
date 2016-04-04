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
    
    // MARK: - outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var questionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - life process
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // 去除NavigationBar的边界
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.imageWithColor(ThemeGreenColor), forBarPosition: .Any, barMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
        
        scrollViewHeight.constant = nextButton.frame.maxY + 50.0
        
        RACObserve(self.questionView, keyPath: "viewHeight") ~> RAC(questionViewHeight, "constant")
    }
    
    @IBAction func changeQuestionType(sender: UISegmentedControl)
    {
        questionView.changeQuestionType(QuestionType(rawValue: sender.selectedSegmentIndex)!)
    }
    
}
