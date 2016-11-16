//
//  QuizCell.swift
//  SmartClass
//
//  Created by Vernon on 16/9/14.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell
{
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    static let cellHeight: CGFloat = 85.0

}

extension QuizCell
{
    func configureWithQuiz(_ quiz: Quiz)
    {
        contentLabel.text = quiz.content
        nameLabel.text = quiz.name
        dateLabel.text = quiz.date?.dateWithHourString
    }
}
