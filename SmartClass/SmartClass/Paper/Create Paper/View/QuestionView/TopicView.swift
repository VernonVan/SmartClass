//
//  TopicView.swift
//  SmartClass
//
//  Created by FSQ on 16/8/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

@IBDesignable class TopicView: UIView
{
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var topicTextView: UIPlaceHolderTextView!
    
    static let cellHeight: CGFloat = 80.0
    
    @IBInspectable
    var number: String? {
        didSet {
            numberLabel.text = number
        }
    }
    
    @IBInspectable
    var topicPlaceholder: String? {
        didSet {
            topicTextView.placeholder = topicPlaceholder
        }
    }
    
    var topic: String? {
        return topicTextView.text
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
        topicTextView.text = nil
    }

}

extension TopicView
{
    func configureWithQuestion(question: Question)
    {
        numberLabel.text = "\(question.index+1)."
        topicTextView.text = question.topic
    }
}

