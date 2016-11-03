//
//  HistoryQuizCell.swift
//  SmartClass
//
//  Created by Vernon on 16/9/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class HistoryQuizCell: UITableViewCell
{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    static let cellHeight: CGFloat = 80.0

}

extension HistoryQuizCell
{
    func configureWithHistoryQuiz(_ historyQuiz: HistoryQuiz)
    {
        nameLabel.text = historyQuiz.date?.dateString
        numberLabel.text = "\(historyQuiz.numberOfQuiz)人提问"
    }
}
