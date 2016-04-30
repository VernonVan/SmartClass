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
    var canvasColor = UIColor.redColor()
    var canvasAlpha: Float = 0.5
    
    private var arrayStrokes = NSMutableArray()
    
    
    // MARK: - UIResponder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if touches.count >= 2 {
            return
        }
        
        let arrayPointsInStroke = NSMutableArray()
        let dictStroke = NSMutableDictionary()
        dictStroke.setObject(arrayPointsInStroke, forKey: "points")
        dictStroke.setObject(canvasColor, forKey: "color")
        dictStroke.setObject(canvasSize, forKey: "size")
        dictStroke.setObject(canvasAlpha, forKey: "alpha")
        
        let point = touches.first!.locationInView(self)
        arrayPointsInStroke.addObject(NSStringFromCGPoint(point))
        arrayStrokes.addObject(dictStroke)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if touches.count>=2 {
            return
        }
        
        let point = touches.first!.locationInView(self)
        let arrayPointsInStroke = (arrayStrokes.lastObject as? NSMutableDictionary)?.objectForKey("points") as? NSMutableArray
        arrayPointsInStroke?.addObject(NSStringFromCGPoint(point))
        
        setNeedsDisplay()
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        return self
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        return true
    }
    
    override func drawRect(rect: CGRect)
    {
        let times = arrayStrokes.count
        
        for i in 0 ..< times {
            let dictStroke = arrayStrokes.objectAtIndex(i) as? NSDictionary
            let arrayPointsInStroke = dictStroke?.objectForKey("points") as? NSArray
            
            let alpha = dictStroke?.objectForKey("alpha") as? CGFloat
            let colorWithoutAlpha = dictStroke?.objectForKey("color") as? UIColor
            let color = UIColor(color: colorWithoutAlpha!, alpha: alpha!)
            color.set()
                
            let pathLines = UIBezierPath()
            let pointStart = CGPointFromString( (arrayPointsInStroke?.objectAtIndex(0) as? String)! )
            pathLines.moveToPoint(pointStart)
            for j in 0..<arrayPointsInStroke!.count-1 {
                let pointNext = CGPointFromString((arrayPointsInStroke?.objectAtIndex(j+1) as? String)!)
                pathLines.addLineToPoint(pointNext)
            }
            
            let size = dictStroke?.objectForKey("size") as? CGFloat
            pathLines.lineWidth = CGFloat(size!)
            pathLines.lineJoinStyle = CGLineJoin.Round
            pathLines.lineCapStyle = CGLineCap.Round
            pathLines.stroke()
        }
    }
    
    func clearCanvas()
    {
        arrayStrokes.removeAllObjects()
        setNeedsDisplay()
    }
    
}
