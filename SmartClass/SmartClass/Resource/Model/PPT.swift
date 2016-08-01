//
//  PPT.swift
//  SmartClass
//
//  Created by Vernon on 16/7/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

struct PPT
{
    /// PPT名
    var name: String?
    
    /// PPT封面
    var coverImage: PPTView
    
    /// PPT创建日期
    var createDate: NSDate?
}

extension UITableViewCell
{
    func configureCellForPPT(ppt: PPT?)
    {
        textLabel?.text = ppt?.name
        detailTextLabel?.text = ppt?.createDate?.dateString
//        addSubview(ppt!.coverImage)
    }
}