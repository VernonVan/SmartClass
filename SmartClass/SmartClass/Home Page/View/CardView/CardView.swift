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
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
