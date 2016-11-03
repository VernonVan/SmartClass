//
//  ResourceCell.swift
//  SmartClass
//
//  Created by Vernon on 16/9/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class ResourceCell: UITableViewCell
{
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    
    static let cellHeight: CGFloat = 80.0
    
}

extension ResourceCell
{
    func configureCellForPPT(_ ppt: PPT?)
    {
        guard let ppt = ppt else {
            return
        }
        
        typeImageView.image = UIImage(named: "ppt")
        nameLabel.text = ppt.name
        sizeLabel.text = ppt.size ?? "0M"
        timeLabel.text = ppt.createDate?.dateString
    }
    
    func configureCellForResource(_ resource: Resource?)
    {
        guard let resource = resource else {
            return
        }
        
        nameLabel.text = resource.name
        sizeLabel.text = resource.size ?? "0M"
        timeLabel.text = resource.createDate?.dateString
        
        switch resource.type {
        case .word:
            typeImageView.image = UIImage(named: "word")
        case .excel:
            typeImageView.image = UIImage(named: "excel")
        case .pdf:
            typeImageView.image = UIImage(named: "pdf")
        case .other:
            typeImageView.image = UIImage(named: "none")
        }
    }
    
}
