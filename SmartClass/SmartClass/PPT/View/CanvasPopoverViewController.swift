//
//  CanvasPopoverViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/4/25.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit

class CanvasPopoverViewController: UIViewController
{
    var delegate: CanvasPopoverDelegate?

    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    var color = UIColor.redColor()
    var size = 5.0
    var alpha: Float = 1.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        initView()
    }
    
    func initView()
    {
        sizeSlider.tintColor = color
        alphaSlider.tintColor = color
        
        sizeSlider.value = Float(size/10)
        
        alphaSlider.value = alpha
    }
    
    // MARK: - Actions

    @IBAction func changeColorActions(button: UIButton)
    {
        let color = button.backgroundColor!
        delegate?.changeCanvasColor(color)
        sizeSlider.tintColor = color
        alphaSlider.tintColor = color
    }
    
    @IBAction func changeSizeAction(slider: UISlider)
    {
        delegate?.changeCanvasSize(Double(slider.value*10))
    }
    
    @IBAction func changeAlphaAction(slider: UISlider)
    {
        delegate?.changeCanvasAlpha(slider.value)
    }
    
    
}
