//
//  UndefineResourceViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class UndefineResourceViewController: UIViewController
{
    var resourceURL: NSURL?
    
    @IBOutlet weak var resourceInformationLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = resourceURL?.lastPathComponent
        resourceInformationLabel.text = String(format: "%.1fMB", getResourceSizeMB())
    }

    func getResourceSizeMB() -> Double
    {
        var fileSize : Double = 0.0
        
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath((resourceURL?.path)!)
            if let _attr = attr {
                fileSize = Double(_attr.fileSize())
            }
        } catch {
            print("Error: \(error)")
        }
        return fileSize / 1024.0 / 1024.0
    }
    
}
