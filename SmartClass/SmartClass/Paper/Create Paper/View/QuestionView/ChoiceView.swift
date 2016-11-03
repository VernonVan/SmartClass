//
//  ChoiceView.swift
//  SmartClass
//
//  Created by FSQ on 16/8/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RxSwift

@IBDesignable class ChoiceView: UIView
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choiceTextField: UITextField!
    
    static let cellHeight: CGFloat = 44.0
    
    var isCorrectAnswer = false

    @IBInspectable
    var index: Int? = nil
    
    @IBInspectable
    var imageName = "emptyChoice" {
        didSet {
            imageView.image = UIImage(named: imageName)
        }
    }
    
    @IBInspectable
    var choicePlaceholder: String? {
        didSet {
            choiceTextField.placeholder = choicePlaceholder
        }
    }
    
    var choiceText: String? {
        return choiceTextField.text
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        _ = loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        _ = loadViewFromNib()
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        return view
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if let value = value as? Int? , key == "index" {
            self.index = value
        }
    }
    
    func selectAnswer()
    {
        if isCorrectAnswer == false {
            isCorrectAnswer = true
            imageView.image = UIImage(named: "selectedChoice")
        } else {
            isCorrectAnswer = false
            imageView.image = UIImage(named: "emptyChoice")
        }
    }
    
    func deselectAnswer()
    {
        isCorrectAnswer = false
        imageView.image = UIImage(named: "emptyChoice")
    }
    
    func clearContent()
    {
        isCorrectAnswer = false
        imageView.image = UIImage(named: "emptyChoice")
        choiceTextField.text = nil
    }
    
}

enum ChoiceIndex: Int, CustomStringConvertible
{
    case a = 0, b, c, d
    
    var description: String {
        switch self {
        case .a:
            return "选项A"
        case .b:
            return "选项B"
        case .c:
            return "选项C"
        case .d:
            return "选项D"
        }
    }
}
