//
//  ResultHeaderCell.swift
//  SmartClass
//
//  Created by Vernon on 16/7/22.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ResultHeaderCell: UITableViewCell
{

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
  
}

extension ResultHeaderCell
{
    func configureForPaper(paper: Paper?)
    {
        nameLabel.text = paper?.name
        descriptionLabel.text = paper?.blurb
    }
}
