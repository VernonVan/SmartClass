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
                numberLabel.setTitle("\(number)", for: UIControlState())
                numberLabel.setBackgroundImage(UIImage(named: "badge"), for: UIControlState())
            } else {
                numberLabel.setTitle(nil, for: UIControlState())
                numberLabel.setBackgroundImage(nil, for: UIControlState())
            }
        }
    }
    
    // MARK: - Lifecycle
    
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
        view.layer.cornerRadius = 6.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(netHex: 0xEEEEEE).cgColor
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if let value = value as? Int? , key == "number" {
            self.number = value
        }
    }
    
}
