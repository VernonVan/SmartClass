//
//  ChartViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController
{
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!

    var dataSourceDict: [String: Int]? // ["passStudents":4, "failStudents": 4, "absentStudents": 2, "questionNumber": 4, "0": 4, "1": 2, "3": 0, "4": 5]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpPieChartView()
        setPieChartData()
        pieChartView.animate(xAxisDuration: 1.0, easingOption: .EaseOutBack)
        
        setUpBarChartView()
        setBarChartData()
        barChartView.animate(yAxisDuration: 1.0)
    }
    
    func setUpPieChartView()
    {
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.58
        pieChartView.transparentCircleRadiusPercent = 0.61
        pieChartView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = "总体得分"
        
        pieChartView.descriptionText = ""
        pieChartView.noDataTextDescription = "没有学生信息"
        
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0.0
        pieChartView.rotationEnabled = true
        pieChartView.highlightPerTapEnabled = true

        let l = pieChartView.legend
        l.position = ChartLegend.Position.BelowChartRight
        l.xEntrySpace = 0.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    func setPieChartData()
    {
        var yVals = [BarChartDataEntry]()
        if let dict = dataSourceDict {
            yVals.append(BarChartDataEntry(value: Double(dict["passStudents"]!), xIndex: 0))
            yVals.append(BarChartDataEntry(value: Double(dict["failStudents"]!), xIndex: 1))
            yVals.append(BarChartDataEntry(value: Double(dict["absentStudents"]!), xIndex: 2))
        }
        
        var xVals = [String]()
        xVals.append(NSLocalizedString("及格", comment: ""))
        xVals.append(NSLocalizedString("不及格", comment: ""))
        xVals.append(NSLocalizedString("待考", comment: ""))
        
        let dataSet = PieChartDataSet(yVals: yVals, label: nil)
        dataSet.sliceSpace = 2.0
        
        var colors = [NSUIColor]()
        colors.insertContentsOf(ChartColorTemplates.colorful(), at: 0)
        colors.insertContentsOf(ChartColorTemplates.joyful(), at: 1)
        dataSet.colors = [ThemeGreenColor, ThemeRedColor, UIColor.grayColor()]
        
        let data = PieChartData(xVals: xVals, dataSets: [dataSet])
        let pFormatter = NSNumberFormatter()
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = "%"
        data.setValueFormatter(pFormatter)
        data.setValueTextColor(UIColor.whiteColor())
        
        pieChartView.data = data
        pieChartView.highlightValue(nil)
    }

    func setUpBarChartView()
    {
        barChartView.descriptionText = ""
        barChartView.noDataTextDescription = "没有学生考试"
        
        barChartView.maxVisibleValueCount = 40
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.spaceBetweenLabels = 0
        xAxis.drawGridLinesEnabled = false
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        
        barChartView.legend.enabled = false
    }

    func setBarChartData()
    {
        if let count = dataSourceDict?["questionNumber"]  {
            var yVals = [BarChartDataEntry]()
            for index in 0 ..< count {
                yVals.append(BarChartDataEntry(value: Double(dataSourceDict!["\(index)"]!), xIndex: index))
            }
            
            var xVals = [String]()
            for index in 0 ..< count {
                xVals.append("第\(index+1)题")
            }
            
            let dataSet = BarChartDataSet(yVals: yVals, label: "DataSet")
            dataSet.colors = ChartColorTemplates.material()
            dataSet.drawValuesEnabled = false
                
            let data = BarChartData(xVals: xVals, dataSets: [dataSet])
            barChartView.data = data
        }
    }
    
}
