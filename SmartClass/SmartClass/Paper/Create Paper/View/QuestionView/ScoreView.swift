//
//  ScoreView.swift
//  SmartClass
//
//  Created by FSQ on 16/8/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

@IBDesignable class ScoreView: UIView
{
    
    @IBOutlet weak var scoreTextField: UITextField!
    
    static let cellHeight: CGFloat = 44.0
    
    @IBInspectable
    var scorePlaceholder: String? {
        didSet {
            scoreTextField.placeholder = scorePlaceholder
        }
    }
    
    var score: Int {
        return Int(scoreTextField.text!) ?? 0
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        return view
    }
    
    func clearContent()
    {
        scoreTextField.text = nil
    }
    
}

extension ScoreView
{
    func configureWithQuestion(question: Question)
    {
        if let score = question.score.value {
            scoreTextField.text = "\(score)"
        } else {
            scoreTextField.placeholder = "\(0)"
        }
        
    }
}
