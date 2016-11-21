//
//  IssuingPaperViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/20.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RealmSwift

class IssuingPaperViewController: UIViewController
{
    var paper: Paper?
    
    @IBOutlet weak var chartView: PieChartView!
    
    fileprivate var studentNumber: Int {
        let realm = try! Realm()
        return realm.objects(Student.self).count
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI()
    {
        title = paper?.name
        
        setupPieChartView()
        
        refresh()
    }
    
    func setupPieChartView()
    {
        chartView.holeRadiusPercent = 0.84
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.text = ""
        chartView.drawHoleEnabled = true
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.drawCenterTextEnabled = true
        
        let legend = chartView.legend
        legend.enabled = false
    }
  
    // MARK: - Action
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem)
    {
        refresh()
    }
    
    @IBAction func finishExamAction()
    {
        let alert = UIAlertController(title: NSLocalizedString("结束考试？", comment: ""), message: NSLocalizedString("结束考试后学生都不能再进行考试！", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .destructive) { [weak self] (_) in
            self?.finishExam()
        }
        alert.addAction(doneAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        if segue.identifier == "previewPaper" {
            if let desVC = segue.destination as? PreviewRootViewController {
                desVC.paper = paper
            }
        }
    }
    
    // MARK: - Private method
    
    func refresh()
    {
        let resultNumber = paper!.results.count
        
        let centerText = NSMutableAttributedString(string: "已交卷\n\(resultNumber)/\(studentNumber)")
        centerText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)], range: NSMakeRange(0, centerText.length))
        centerText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 24.0), NSForegroundColorAttributeName: ThemeGreenColor], range: NSMakeRange(4, "\(resultNumber)".length))
        chartView.centerAttributedText = centerText
        
        var yVals = [BarChartDataEntry]()
        yVals.append(BarChartDataEntry(x: Double(resultNumber), y: 0))
        yVals.append(BarChartDataEntry(x: Double(studentNumber - resultNumber), y: 1))
//        yVals.append(BarChartDataEntry(value: Double(resultNumber), xIndex: 0))
//        yVals.append(BarChartDataEntry(value: Double(studentNumber - resultNumber), xIndex: 1))
        
        var xVals = [String]()
        xVals.append(NSLocalizedString("已交卷", comment: ""))
        xVals.append(NSLocalizedString("未交卷", comment: ""))
        
        let dataSet = PieChartDataSet(values: yVals, label: nil)
        dataSet.colors = [UIColor(netHex: 0x23E5A3), UIColor(netHex: 0xdddddd)]
        
        let data = PieChartData(dataSets: [dataSet])
//        let data = PieChartData(xVals: xVals, dataSets: [dataSet])
        chartView.data = data
        
        chartView.drawEntryLabelsEnabled = false
        for set in chartView.data!.dataSets {
            set.drawValuesEnabled = false
        }
    }
    
    func finishExam()
    {
        let realm = try! Realm()
        try! realm.write {
            paper?.state = PaperIssueState.finished.rawValue
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
