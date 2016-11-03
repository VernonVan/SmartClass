//
//  SegueHandlerType.swift
//  SegueIdentifier
//
//  Created by FSQ on 16/3/10.
//  Copyright (c) 2016年 Vernon. All rights reserved.
//

import UIKit
import Foundation

protocol SegueHandlerType {
    associatedtype 	SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController,
    SegueIdentifier.RawValue == String
{
    func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
        let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).")
        }
        
        return segueIdentifier
    }
}
