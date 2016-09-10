//
//  SignUpSheetCell.swiftsignedCell
//  SmartClass
//
//  Created by Vernon on 16/9/2.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class SignUpSheetCell: UITableViewCell
{
 
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var signImageView: UIImageView!

    func selectCell()
    {
        nameLabel.textColor = ThemeBlueColor
        signImageView.image = UIImage(named: "signedCell")
    }
    
    func deselectCell()
    {
        nameLabel.textColor = UIColor(netHex: 0x999999)
        signImageView.image = UIImage(named: "unsignedCell")
    }
    
}
