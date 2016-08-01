//
//  QRCodeViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Toast

class QRCodeViewController: UIViewController
{
    var url: String?

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    
    private var qrCodeImage: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        if url == "nil" {
            let alert = UIAlertController(title: NSLocalizedString("无法生成二维码", comment: ""),
                                          message: NSLocalizedString("请确保Wifi网络可用", comment: ""),
                                          preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default, handler: { (_) in
                self.backAction()
            })
            alert.addAction(doneAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        initUI()
    }
    
    func initUI()
    {
        let text = NSMutableAttributedString(string: "或者访问\(url!)")
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange(location: 0, length: 4))
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor(netHex: 0x2196F3), range: NSRange(location: 4, length: text.length-4))
        urlLabel.attributedText = text
        
        qrCodeImageView.image = convertStringToQRCodeImage(url)
    }
    
    func convertStringToQRCodeImage(string: String?) -> UIImage
    {
        let data = string?.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")          // 需要编码的信息
        filter?.setValue("Q", forKey: "inputCorrectionLevel")   // 二维码对象的修正格式
        let ciImage = filter?.outputImage
        let image = UIImage(CIImage: ciImage!)
        
        // 无损的整点缩放，获得放大15倍的清晰二维码图像
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * 15, height: image.size.height * 15))
        let resizeContext = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(resizeContext, .None)
        image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width * 15, height: image.size.height * 15))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    
    // MARK: - Action
    
    @IBAction func saveAction(sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: NSLocalizedString("保存图片", comment: ""), message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .Destructive, handler: nil)
        alert.addAction(cancelAction)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default) { [weak self] (_) in
            self?.saveImageAction()
        }
        alert.addAction(doneAction)  
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveImageAction()
    {
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.image!, self, #selector(QRCodeViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>)
    {
        guard error == nil else {
            view.makeToast(NSLocalizedString("保存失败！", comment: ""), duration: 0.2, position: CSToastPositionBottom)
            return
        }
        
        view.makeToast(NSLocalizedString("保存成功", comment: ""), duration: 0.2, position: CSToastPositionBottom)
    }
    
    func backAction()
    {
        navigationController?.popViewControllerAnimated(true)
    }

}

