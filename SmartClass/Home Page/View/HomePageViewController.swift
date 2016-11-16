//
//  HomePageViewController.swift
//  SmartClass
//
//  Created by Vernon on 16/7/25.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift

class HomePageViewController: UIViewController
{
    
    @IBOutlet weak var paperCardView: CardView!
    @IBOutlet weak var resourceCardView: CardView!
    @IBOutlet weak var studentCardView: CardView!
    @IBOutlet weak var quizCardView: CardView!
    @IBOutlet weak var signUpSheetCardView: CardView!

    let realm = try! Realm()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshCardViewBadgeNumber()
    }
    
    func refreshCardViewBadgeNumber()
    {
        DispatchQueue.global(qos: .default).async {
            let signUpSheetPath = ConvenientFileManager.signUpSheetURL.path
            let pptPath = ConvenientFileManager.pptURL.path
            let resourcePath = ConvenientFileManager.resourceURL.path
            var resourceCount = 0, signUpSheetCount = 0
            do {
                let pptCount = try FileManager.default.contentsOfDirectory(atPath: pptPath).filter({ (fileName) -> Bool in
                    let url = ConvenientFileManager.pptURL.appendingPathComponent(fileName)
                    return url.pathExtension.contains("pptx")
                }).count
                let otherCount = try FileManager.default.contentsOfDirectory(atPath: resourcePath).count
                resourceCount = pptCount + otherCount
                signUpSheetCount = try FileManager.default.contentsOfDirectory(atPath: signUpSheetPath).count
            } catch let error as NSError {
                print("HomePageViewController refreshCardViewBadgeNumber error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async(execute: {
                self.paperCardView.number = self.realm.objects(Paper.self).count
                self.resourceCardView.number = resourceCount
                self.studentCardView.number = self.realm.objects(Student.self).count
                self.quizCardView.number = self.realm.objects(Quiz.self).filter("date > %@", Date.today).count
                self.signUpSheetCardView.number = signUpSheetCount
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showPaperList" {
            if let desVC = segue.destination as? PaperListViewController {
                let paperListViewModel = PaperListViewModel()
                desVC.viewModel = paperListViewModel
            }
        } else if segue.identifier == "showResourceList" {
            if let desVC = segue.destination as? ResourceListViewController {
                let viewModel = ResourceListViewModel()
                desVC.viewModel = viewModel
            }
        } else if segue.identifier == "StudentList" {
            if let desVC = segue.destination as? StudentListViewController {
                desVC.viewModel = StudentListViewModel()
            }
        } else if segue.identifier == "StudentQuiz" {
            if let desVC = segue.destination as? QuizListViewController {
                let today = Date.today
                let tomorrow = Date.tomorrow
                desVC.fromDate = today
                desVC.toDate = tomorrow
            }
        } else if segue.identifier == "SignUpSheetList" {
            if let desVC = segue.destination as? SignUpSheetListViewController {
                desVC.viewModel = SignUpSheetListViewModel()
            }
        } else if segue.identifier == "showQRCode" {
            if let desVC = segue.destination as? QRCodeViewController {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                desVC.url = appDelegate.webUploaderURL
            }
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

}
