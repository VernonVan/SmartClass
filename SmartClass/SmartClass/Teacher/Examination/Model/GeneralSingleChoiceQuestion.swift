//
//  GeneralSingleChoiceQuestion.swift
//  SmartClass
//
//  Created by Vernon on 16/3/4.
//  Copyright © 2016年 Vernon. All rights reserved.
//

class GeneralSingleChoiceQuestion: SingleChoiceQuestion, ChoiceQuestionDelegate
{
    func checkIntegrity() -> Bool
    {
        if topic?.length > 0 && options?.count == 4 && correctAnswer?.length > 0 && score > 0 {
                if options![0].length > 0 && options![1].length > 0 &&  options![2].length > 0 && options![3].length > 0{
                    return true
                }
        }
        
        return false
    }
    
    func markQuestion() -> Int
    {
        return 0
    }
}
