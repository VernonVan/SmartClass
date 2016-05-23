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

    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var dataSourceDict: [String: Int]?
    
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
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        viewHeight.constant = view.bounds.width * 2.5
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        viewHeight.constant = size.width * 2.5
    }
    
    // MARK: - Pie chart
    func setUpPieChartView()
    {
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.58
        pieChartView.transparentCircleRadiusPercent = 0.61
        pieChartView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = NSLocalizedString("总体得分", comment: "")
        pieChartView.descriptionText = ""
        pieChartView.noDataTextDescription = NSLocalizedString("没有学生信息", comment: "")
        
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0.0
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = true

        let l = pieChartView.legend
        l.position = .RightOfChart
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
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(pFormatter)
        data.setValueTextColor(UIColor.whiteColor())
        
        pieChartView.data = data
        pieChartView.highlightValue(nil)
    }

    func setUpBarChartView()
    {
        barChartView.descriptionText = ""
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
            dataSet.drawValuesEnabled = true
                
            let data = BarChartData(xVals: xVals, dataSets: [dataSet])
            barChartView.data = data
        }
    }
    
}
