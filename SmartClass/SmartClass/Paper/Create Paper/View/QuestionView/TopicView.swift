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
    
    func clearContent()
    {
        topicTextView.text = nil
    }

}

extension TopicView
{
    func configureWithQuestion(_ question: Question)
    {
        numberLabel.text = "\(question.index+1)."
        topicTextView.text = question.topic
    }
}

