//
//  ChartViewController.swift
//  SmartClass
//
//  Created by FSQ on 16/5/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ResultChartViewController: UIViewController
{
    var paper: Paper!
    
    @IBOutlet weak var chartView: BarChartView!
 
    private let realm = try! Realm()
    private var studentNumber = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        studentNumber = realm.objects(Student).count
        
        initChartView()
        setChartViewData()
        chartView.animate(yAxisDuration: 1.0)
    }
    
    func initChartView()
    {
        chartView.descriptionText = ""
        chartView.maxVisibleValueCount = 20
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.legend.enabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.drawGridLinesEnabled = false

        let leftAxisFormatter = NSNumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 100
        leftAxisFormatter.positiveSuffix = "%"
        leftAxisFormatter.negativeSuffix = "%"
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = leftAxisFormatter
        leftAxis.axisMinValue = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
    }
    
    func setChartViewData()
    {
        let questionCount = paper.questions.count
        var xVals = [String]()
        var yVals = [BarChartDataEntry]()
        
        var correctNumbers = [Double]()
        for _ in 0..<questionCount {
            correctNumbers.append(0)
        }
        
        for result in paper.results {
            for correctNumber in result.correctQuestionNumbers {
                correctNumbers[correctNumber.number] += 1
            }
        }
        
        for index in 0..<questionCount {
            yVals.append(BarChartDataEntry(value: correctNumbers[index] / Double(studentNumber) * 100, xIndex: index))
            index == 0 ? xVals.append("第1题") : xVals.append("\(index+1)")
        }
        
        let dataSet = BarChartDataSet(yVals: yVals, label: "每道题的答对比例")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.drawValuesEnabled = true
        let data = BarChartData(xVals: xVals, dataSets: [dataSet])
        chartView.data = data
    }
    
}
