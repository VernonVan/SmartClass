//
//  TopicCell.swift
//  SmartClass
//
//  Created by Vernon on 16/7/22.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell
{

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var topicLabel: UILabel!
    
}

extension TopicCell
{
    func configureForQuestion(_ question: Question)
    {
        switch QuestionType(typeNum: question.type)
        {
        case .some(.singleChoice):
            typeLabel.text = NSLocalizedString("单选题", comment: "")
        case .some(.multipleChoice):
            typeLabel.text = NSLocalizedString("多选题", comment: "")
        case .some(.trueOrFalse):
            typeLabel.text = NSLocalizedString("判断题", comment: "")
        default:
            typeLabel.text = nil
        }
        
        topicLabel.text = "\(question.index+1).\(question.topic!)"
    }
}
