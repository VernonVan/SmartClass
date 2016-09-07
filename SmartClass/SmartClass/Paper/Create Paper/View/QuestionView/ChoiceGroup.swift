//
//  ChoiceGroup.swift
//  SmartClass
//
//  Created by FSQ on 16/8/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift

class ChoiceGroup
{
    var answers: String {
        var answers = ""
        if cells[0].isCorrectAnswer { answers += "A" }
        if cells[1].isCorrectAnswer { answers += "B" }
        if cells[2].isCorrectAnswer { answers += "C" }
        if cells[3].isCorrectAnswer { answers += "D" }
        return answers
    }
    
    /// 可多选的
    var isMultipleAnswer = false
    
    private var cells = [ChoiceView]()
    
    private let disposeBag = DisposeBag()
    
    func insertCells(cells: [ChoiceView])
    {
        var index = 0
        for cell in cells {
            self.cells.insert(cell, atIndex: index)
            index += 1
        }
    }
    
    func selectCellAtIndex(index: Int)
    {
        if isMultipleAnswer == false {
            for cell in cells {
                cell.deselectAnswer()
            }
        }
        
        cells[index].selectAnswer()
    }
    
    func configureWithQuestion(question: Question)
    {
        cells[0].choiceTextField.text = question.choiceA
        cells[1].choiceTextField.text = question.choiceB
        cells[2].choiceTextField.text = question.choiceC
        cells[3].choiceTextField.text = question.choiceD
        
        guard let type = QuestionType(typeNum: question.type) else {
            return
        }
        isMultipleAnswer = (type == .MultipleChoice) ? true : false
        
        guard let answers = question.answers else {
            return
        }
        for choice in answers.characters {
            let index = Int(choice.unicodeScalarCodePoint()) - 65
            cells[index].selectAnswer()
        }
    }
    
    func clearContents()
    {
        for index in 0..<4 {
            cells[index].clearContent()
        }
    }

}
