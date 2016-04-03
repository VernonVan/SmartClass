//
//  PaperView.swift
//  SmartClass
//
//  Created by Vernon on 16/4/1.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import SnapKit

class QuestionView: UIView, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Properties
    
    private let tableview = UITableView()
    var questionType = QuestionType.SingleChoice {
        didSet {
            setNeedsDisplay()
        }
    }
    private var choiceCount: Int {
        return questionType==QuestionType.TrueOrFalse ? 2 : 4
    }
    private let topicCell = UITableViewCell()
 //   private let choiceCells =  [UITableViewCell]()
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        tableview.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: frame.height)
        tableview.dataSource = self
        tableview.delegate = self
        self.addSubview(tableview)
        
        let textView = UIPlaceHolderTextView()
        let label = UILabel()
        
        let text = "单选"
        let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(12) ,
                          NSForegroundColorAttributeName : UIColor.blackColor()]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        label.layer.borderWidth = 1
        topicCell.contentView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.centerY.equalTo(topicCell)
            make.left.equalTo(topicCell).offset(3)
        }
        
        textView.backgroundColor = UIColor.lightGrayColor()
        textView.placeholder = NSLocalizedString("输入问题描述", comment: "")
        textView.placeholderColor = UIColor.redColor()
        topicCell.contentView.addSubview(textView)
        textView.snp_makeConstraints { (make) in
            make.edges.equalTo(topicCell).inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
        }
    }
    
    override func layoutSubviews()
    {
        tableview.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
//        case 1:
//            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            return topicCell
//        case 1:
//            return choiceCells[indexPath.row]
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            return 50
        default:
            return 44
        }
    }
    
    // TODO: - 处理屏幕旋转
    
}
