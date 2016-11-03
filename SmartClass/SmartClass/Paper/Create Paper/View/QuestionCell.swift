//
//  QuestionCell.swift
//  SmartClass
//
//  Created by Vernon on 16/7/21.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell
{

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var isCompletedImageView: UIImageView!
    
}

extension QuestionCell
{
    func configurForQuestion(_ question: Question?)
    {
        guard let question = question else {
            return
        }
        
        switch QuestionType(typeNum: question.type)!
        {
        case .singleChoice:
            typeLabel.text = NSLocalizedString("单选", comment: "")
        case .multipleChoice:
            typeLabel.text = NSLocalizedString("多选", comment: "")
        case .trueOrFalse:
            typeLabel.text = NSLocalizedString("判断", comment: "")
        }
        
//        topicLabel.text = question.topic
        let isEmptyTopic = (question.topic ?? "").isEmpty
        let text = (isEmptyTopic ? NSLocalizedString("尚未填写题目描述", comment: "") : question.topic!)
        let attributes = [NSForegroundColorAttributeName: (isEmptyTopic ? UIColor.lightGray : UIColor.darkText)]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        topicLabel.attributedText = attributedText
        
        let isCompletedImageName = question.isCompleted ? "completeQuestion" : "uncompleteQuestion"
        isCompletedImageView.image = UIImage(named: isCompletedImageName)
    }
}
