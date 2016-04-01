//
//  OptionCell.swift
//  SmartClass
//
//  Created by Vernon on 16/3/15.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell
{
    // MARK: - Properties
    
    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var optionText: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
