//
//  canvasView.swift
//  SmartClass
//
//  Created by Vernon on 15/9/1.
//  Copyright (c) 2015年 Vernon. All rights reserved.
//

import UIKit

class CanvasView: UIView
{
    var canvasSize = 5.0
    var canvasColor = UIColor.red
    var canvasAlpha: Float = 0.5
    
    fileprivate var arrayStrokes = NSMutableArray()
    
    
    // MARK: - UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if touches.count >= 2 {
            return
        }
        
        let arrayPointsInStroke = NSMutableArray()
        let dictStroke = NSMutableDictionary()
        dictStroke.setObject(arrayPointsInStroke, forKey: "points" as NSCopying)
        dictStroke.setObject(canvasColor, forKey: "color" as NSCopying)
        dictStroke.setObject(canvasSize, forKey: "size" as NSCopying)
        dictStroke.setObject(canvasAlpha, forKey: "alpha" as NSCopying)
        
        let point = touches.first!.location(in: self)
        arrayPointsInStroke.add(NSStringFromCGPoint(point))
        arrayStrokes.add(dictStroke)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if touches.count>=2 {
            return
        }
        
        let point = touches.first!.location(in: self)
        let arrayPointsInStroke = (arrayStrokes.lastObject as? NSMutableDictionary)?.object(forKey: "points") as? NSMutableArray
        arrayPointsInStroke?.add(NSStringFromCGPoint(point))
        
        setNeedsDisplay()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        return self
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        return true
    }
    
    override func draw(_ rect: CGRect)
    {
        let times = arrayStrokes.count
        
        for i in 0 ..< times {
            let dictStroke = arrayStrokes.object(at: i) as? NSDictionary
            let arrayPointsInStroke = dictStroke?.object(forKey: "points") as? NSArray
            
            let alpha = dictStroke?.object(forKey: "alpha") as? CGFloat
            let colorWithoutAlpha = dictStroke?.object(forKey: "color") as? UIColor
            let color = UIColor(color: colorWithoutAlpha!, alpha: alpha!)
            color.set()
                
            let pathLines = UIBezierPath()
            let pointStart = CGPointFromString( (arrayPointsInStroke?.object(at: 0) as? String)! )
            pathLines.move(to: pointStart)
            for j in 0..<arrayPointsInStroke!.count-1 {
                let pointNext = CGPointFromString((arrayPointsInStroke?.object(at: j+1) as? String)!)
                pathLines.addLine(to: pointNext)
            }
            
            let size = dictStroke?.object(forKey: "size") as? CGFloat
            pathLines.lineWidth = CGFloat(size!)
            pathLines.lineJoinStyle = CGLineJoin.round
            pathLines.lineCapStyle = CGLineCap.round
            pathLines.stroke()
        }
    }
    
    func clearCanvas()
    {
        arrayStrokes.removeAllObjects()
        setNeedsDisplay()
    }
    
}
