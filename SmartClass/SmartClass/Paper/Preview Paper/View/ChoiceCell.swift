//
//  ChoiceCell.swift
//  SmartClass
//
//  Created by Vernon on 16/7/22.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ChoiceCell: UITableViewCell
{
    
    @IBOutlet weak var choiceImageView: UIImageView!
    
    @IBOutlet weak var choiceLabel: UILabel!

}

extension ChoiceCell
{
    func configureForQuestion(question: Question, choiceNum: Int)
    {
        switch choiceNum {
        case 0:
            choiceLabel.text = question.choiceA
            choiceImageView?.image = UIImage(named: "choiceA")
        case 1:
            choiceLabel.text = question.choiceB
            choiceImageView?.image = UIImage(named: "choiceB")
        case 2:
            choiceLabel.text = question.choiceC
            choiceImageView?.image = UIImage(named: "choiceC")
        case 3:
            choiceLabel.text = question.choiceD
            choiceImageView?.image = UIImage(named: "choiceD")
        default:
            break
        }
        
        if question.answers!.characters.contains(Character(UnicodeScalar(choiceNum+65))) {
            choiceImageView.image = UIImage(named: "correctAnswer")
        }
    }
}