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
    func configurForQuestion(question: Question)
    {
        switch QuestionType(typeNum: question.type)
        {
        case .Some(.SingleChoice):
            typeLabel.text = NSLocalizedString("单选题", comment: "")
        case .Some(.MultipleChoice):
            typeLabel.text = NSLocalizedString("多选题", comment: "")
        case .Some(.TrueOrFalse):
            typeLabel.text = NSLocalizedString("判断题", comment: "")
        default:
            typeLabel.text = nil
        }
        
        topicLabel.text = question.topic
        
        let isCompletedImageName = question.isCompleted ? "completedQuestion" : "uncompletedQuestion"
        isCompletedImageView.image = UIImage(named: isCompletedImageName)
    }
}
