//
//  QuizListViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/9/14.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class QuizListViewController: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var fromDate: Date!
    var toDate: Date!
    var quizs: Results<Quiz>!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let realm = try! Realm()
        quizs = realm.objects(Quiz.self).filter("date BETWEEN {%@, %@}", fromDate, toDate)
        
//        try! realm.write {
//            let quiz1 = Quiz(value: ["content": "第一题怎么做", "name": "卢建晖", "date": NSDate()])
//            realm.add(quiz1)
//            let quiz2 = Quiz(value: ["content": "为什么1+1=2", "name": "刘德华", "date": NSDate()])
//            realm.add(quiz2)
//            let quiz3 = Quiz(value: ["content": "为什么1+1=2", "name": "卢建晖", "date": NSDate(timeIntervalSince1970: 10000000)])
//            realm.add(quiz3)
//        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(netHex: 0xeeeeee)
        tableView.emptyDataSetSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }


}

extension QuizListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return quizs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
        cell.configureWithQuiz(quizs[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return QuizCell.cellHeight
    }
    
}

extension QuizListViewController: DZNEmptyDataSetSource
{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "emptyQuiz")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = NSLocalizedString("本节课暂无学生提问", comment: "")
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
