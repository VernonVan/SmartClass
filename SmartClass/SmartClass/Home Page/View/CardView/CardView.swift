//
//  CardView.swift
//  SmartClass
//
//  Created by Vernon on 16/7/25.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView
{

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var numberLabel: UIButton!
    
    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    @IBInspectable
    var number: Int? {
        didSet {
            if let number = number {
                numberLabel.setTitle("\(number)", forState: .Normal)
                numberLabel.setBackgroundImage(UIImage(named: "badge"), forState: .Normal)
            } else {
                numberLabel.setTitle(nil, forState: .Normal)
                numberLabel.setBackgroundImage(nil, forState: .Normal)
            }
        }
    }
    
    // MARK: - Lifecycle
    
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
        view.layer.cornerRadius = 6.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(netHex: 0xEEEEEE).CGColor
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        return view
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if let value = value as? Int? where key == "number" {
            self.number = value
        }
    }
    
}
