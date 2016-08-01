//
//  Resource.swift
//  SmartClass
//
//  Created by Vernon on 16/7/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

struct Resource
{
    /// 资源名
    var name: String?
    
    /// 创建日期
    var createDate: NSDate?
}

extension UITableViewCell
{
    func configureCellForResource(resource: Resource?)
    {
        textLabel?.text = resource?.name
        detailTextLabel?.text = resource?.createDate?.dateString
    }
}