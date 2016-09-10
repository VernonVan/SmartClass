//
//  AppDelegate.swift
//  SmartClass
//
//  Created by Vernon on 16/2/28.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import UIKit
import RealmSwift
import GCDWebServer
import Reachability
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    let webUploader = GCDWebUploader(uploadDirectory: ConvenientFileManager.uploadURL.path)
    var webUploaderURL: String {
        return "\(self.webUploader.serverURL)"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        print(ConvenientFileManager.paperURL.path!)
        
        initUI()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        addHandlerForWebUploader()
        webUploader.start()
        
        return true
    }
    
    func initUI()
    {
        UITextView.appearance().tintColor = ThemeGreenColor
        UITextField.appearance().tintColor = ThemeGreenColor
        
        IQKeyboardManager.sharedManager().enable = true
    }

    func addHandlerForWebUploader()
    {
        // 发送试卷列表给Web端
        webUploader.addHandlerForMethod("GET", path: "/getPaperList", requestClass: GCDWebServerRequest.self) { (request, completionBlock) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let issuingPapers = self.getIssuingPaperList()
                let response = GCDWebServerDataResponse(data: issuingPapers, contentType: "")
                completionBlock(response)
            })
        }
        
        // 接收确认学生的请求并返回是否是我的学生的确认信息给Web端
        webUploader.addHandlerForMethod("POST", path: "/confirmID", requestClass: GCDWebServerDataRequest.self) { (request, completionBlock) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let dataRequest = request as? GCDWebServerDataRequest {
                    var stuentInformationDict: NSDictionary?
                    do {
                        stuentInformationDict = try NSJSONSerialization.JSONObjectWithData(dataRequest.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    } catch let error as NSError {
                        print("AppDelegate confirmID error: \(error)")
                    }
                    
                    guard let _ = stuentInformationDict, let studentName = stuentInformationDict!["student_name"] as? String, let studentNumber = stuentInformationDict!["student_number"] as? String else {
                        completionBlock(GCDWebServerDataResponse(statusCode: 204))
                        return
                    }
                    
                    let isMyStudent = self.confirmStudentName(studentName, number: studentNumber)
                    do {
                        let responseData = try NSJSONSerialization.dataWithJSONObject(["isMyStudent": isMyStudent], options: NSJSONWritingOptions.PrettyPrinted)
                        completionBlock(GCDWebServerDataResponse(data: responseData, contentType: ""))
                    } catch let error as NSError {
                        print("AppDelegate confirmID error: \(error)")
                    }
                } else {
                    completionBlock(GCDWebServerDataResponse(statusCode: 204))
                }
            })
        }
        
        // 接收某份试卷的请求并返回该试卷的json数据给Web端
        webUploader.addHandlerForMethod("POST", path: "/TestPage/HTML/requestPaper", requestClass: GCDWebServerDataRequest.self) { (request, completionBlock) in
            if let dataRequest = request as? GCDWebServerDataRequest {
                var paperNameDict: NSDictionary?
                do {
                    paperNameDict = try NSJSONSerialization.JSONObjectWithData(dataRequest.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                } catch let error as NSError {
                    print("AppDelegate requestPaper error: \(error)")
                }
                guard let _ = paperNameDict, let paperName = paperNameDict!["name"] as? String else {
                    completionBlock(GCDWebServerDataResponse(statusCode: 204))
                    return
                }

                let paperData = self.getPaperJsonWithName(paperName)
                completionBlock(GCDWebServerDataResponse(data: paperData, contentType: ""))
            } else {
                completionBlock(GCDWebServerDataResponse(statusCode: 204))
            }
        }
        
        // 接收学生考试的答题情况
        webUploader.addHandlerForMethod("POST", path: "/TestPage/HTML/resultData", requestClass: GCDWebServerDataRequest.self) { (request, completionBlock) in
            if let dataRequest = request as? GCDWebServerDataRequest {
                do {
                    if let paperResultDict = try NSJSONSerialization.JSONObjectWithData(dataRequest.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        self.addPaperResultForDict(paperResultDict)
                    }
                } catch let error as NSError {
                    print("AppDelegate addHandlerForWebUploader error: \(error)")
                }
                completionBlock(GCDWebServerDataResponse(statusCode: 200))
            } else {
                completionBlock(GCDWebServerDataResponse(statusCode: 204))
            }
        }
    }
    
    // 将所有发布中的试卷组织成NSData
    func getIssuingPaperList() -> NSData
    {
        let paperArray = NSMutableArray()
        let realm = try! Realm()
        let issuingPapers = realm.objects(Paper).filter("state == 1")
        for paper in issuingPapers {
            paperArray.addObject(["name": paper.name, "blurb": paper.blurb])
        }
        var paperData: NSData!
        do {
            paperData = try NSJSONSerialization.dataWithJSONObject(["papers": paperArray], options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print("AppDelegate getIssuingPaperList error: \(error)")
        }
        return paperData
    }
    
    // 确定该学生是否是我的学生
    func confirmStudentName(name: String, number: String) -> Bool
    {
        let realm = try! Realm()
        if let _ = realm.objects(Student).filter("name = '\(name)' AND number = '\(number)'").first {
            return true
        }
        return false
    }
    
    // 将试卷的信息封装为NSData
    func getPaperJsonWithName(name: String) -> NSData
    {
        let paperUrl = ConvenientFileManager.paperURL.URLByAppendingPathComponent(name)
        return NSData(contentsOfURL: paperUrl)!
    }
    
    // 添加学生的考试结果
    func addPaperResultForDict(paperResultDict: NSDictionary)
    {
        print("学生成绩: \(paperResultDict)")
        guard let paperName = paperResultDict["paper_name"] as? String, let studentName = paperResultDict["student_name"] as? String,
            let studentNumber = paperResultDict["student_number"] as? String, let score = paperResultDict["score"] as? Int,
            var correctQuestions = paperResultDict["result"] as? [Int] else {
            return
        }
        correctQuestions.removeLast()
        
        let realm = try! Realm()
        guard let paper = realm.objects(Paper).filter("name == '\(paperName)'").first else {
            return
        }
        
        print("paper name: \(paper.name)\npaper state: \(paper.state))")
        
        if paper.state == 1 {
            if let _ = paper.results.filter("name == '\(studentName)'").first {
                return
            }
            
            try! realm.write {
                let result = Result(value: ["name": studentName, "number": studentNumber, "score": score])
                for number in correctQuestions {
                    let questionNumber = QuestionNumber(value: ["number": number])
                    result.correctQuestionNumbers.append(questionNumber)
                }
                print("Result: \(result)")
                paper.results.append(result)
            }
        }
    }

}




