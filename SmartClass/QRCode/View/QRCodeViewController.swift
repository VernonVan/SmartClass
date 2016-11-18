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
    var url: URL?

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    
    fileprivate var qrCodeImage: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        if url == nil {
            let alert = UIAlertController(title: NSLocalizedString("无法生成二维码", comment: ""),
                                          message: NSLocalizedString("请确保Wifi网络可用", comment: ""),
                                          preferredStyle: .alert)
            let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: { (_) in
                self.backAction()
            })
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        initUI()
    }
    
    func initUI()
    {
        let text = NSMutableAttributedString(string: "或者访问\(url!)")
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location: 0, length: 4))
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor(netHex: 0x2196F3), range: NSRange(location: 4, length: text.length-4))
        urlLabel.attributedText = text
        
        qrCodeImageView.image = convertStringToQRCodeImageWith(url: url)
    }
    
    func convertStringToQRCodeImageWith(url: URL?) -> UIImage?
    {
        guard let url = url else {
            return nil
        }
        
        let data = url.absoluteString.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")          // 需要编码的信息
        filter?.setValue("Q", forKey: "inputCorrectionLevel")   // 二维码对象的修正格式
        let ciImage = filter?.outputImage
        let image = UIImage(ciImage: ciImage!)
        
        // 无损的整点缩放，获得放大15倍的清晰二维码图像
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * 15, height: image.size.height * 15))
        let resizeContext = UIGraphicsGetCurrentContext()
        resizeContext!.interpolationQuality = .none
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width * 15, height: image.size.height * 15))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage!
    }
    
    // MARK: - Action
    
    @IBAction func saveAction(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: NSLocalizedString("保存图片", comment: ""), message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default) { [weak self] (_) in
            self?.saveImageAction()
        }
        alert.addAction(doneAction)  
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveImageAction()
    {
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.image!, self, #selector(QRCodeViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
    {
        guard error == nil else {
            view.makeToast(NSLocalizedString("保存失败！", comment: ""), duration: 0.2, position: CSToastPositionBottom)
            return
        }
        
        view.makeToast(NSLocalizedString("保存成功", comment: ""), duration: 0.2, position: CSToastPositionBottom)
    }
    
    func backAction()
    {
        _ = navigationController?.popViewController(animated: true)
    }

}

