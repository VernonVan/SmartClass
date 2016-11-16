//
//  HistoryQuizListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/9/18.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

struct HistoryQuiz
{
    var date: Date?
    var numberOfQuiz = 0
}

class HistoryQuizListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!

    var historyQuizs = [HistoryQuiz]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureDataSource()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(netHex: 0xeeeeee)
        tableView.emptyDataSetSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func configureDataSource()
    {
        let realm = try! Realm()
        for quiz in realm.objects(Quiz.self) {
            if let index = isHadHistoryQuiz(quiz) {
                historyQuizs[index].numberOfQuiz += 1
            } else {
                let historyQuiz = HistoryQuiz(date: quiz.date, numberOfQuiz: 1)
                historyQuizs.append(historyQuiz)
            }
        }
    }
    
    func isHadHistoryQuiz(_ quiz: Quiz) -> Int?
    {
        var index = 0
        for historyQuiz in historyQuizs {
            if quiz.date?.dateString == historyQuiz.date?.dateString {
                return index
            }
            index += 1
        }
        return nil
    }

}

extension HistoryQuizListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return historyQuizs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryQuizCell", for: indexPath) as! HistoryQuizCell
        cell.configureWithHistoryQuiz(historyQuizs[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return HistoryQuizCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let quizListVC = storyboard?.instantiateViewController(withIdentifier: "QuizListViewController") as? QuizListViewController {
            let fromDay = historyQuizs[(indexPath as NSIndexPath).row].date
            let toDate = Date.nextDateAfterDate(fromDay!)
            quizListVC.fromDate = fromDay
            quizListVC.toDate = toDate
            navigationController?.pushViewController(quizListVC, animated: true)
            quizListVC.navigationItem.rightBarButtonItem = nil
        }
    }
    
}

extension HistoryQuizListViewController: DZNEmptyDataSetSource
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyQuiz")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("没有历史提问", comment: "" )
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0) ,
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text , attributes: attributes)
    }
}
