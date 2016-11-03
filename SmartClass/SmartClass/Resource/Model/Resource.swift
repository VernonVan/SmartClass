//
//  Resource.swift
//  SmartClass
//
//  Created by Vernon on 16/7/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

enum FileType
{
    case word, excel, pdf, other
}

struct Resource
{
    /// 资源名
    var name: String?
    
    /// 创建日期
    var createDate: Date?
    
    /// 内存大小
    var size: String?
    
    /// 文件类型
    var type: FileType
}

