//
//  PaperListViewModel.swift
//  SmartClass
//
//  Created by FSQ on 16/5/10.
//  Copyright © 2016年 Vernon. All rights reserved.
//

import RxSwift
import RealmSwift

enum PaperType: Int
{
    case editing = 0
    case issuing = 1
    case finished = 2
}

class PaperListViewModel: NSObject
{
    var paperType = PaperType.editing {
        didSet {
            reloadPaper()
        }
    }
    
    fileprivate let realm = try! Realm()
    var showingPapers: Results<(Paper)>!
    
    override init()
    {
        showingPapers = realm.objects(Paper.self).filter("state = 0")
        super.init()
    }
    
    func reloadPaper()
    {
        switch paperType {
        case .editing:
            showingPapers = realm.objects(Paper.self).filter("state = 0")
        case .issuing:
            showingPapers = realm.objects(Paper.self).filter("state = 1")
        case .finished:
            showingPapers = realm.objects(Paper.self).filter("state = 2")
        }
    }
}


// MARK: - TableView

extension PaperListViewModel
{
    
    func numberOfPapers() -> Int
    {
        let count = showingPapers.count
        return count
    }
    
    func paperAtIndexPath(_ indexPath: IndexPath) -> Paper
    {
        let paper = showingPapers[(indexPath as NSIndexPath).row]
        return paper
    }
    
    func deletePaperAtIndexPath(_ indexPath: IndexPath)
    {
        let paper = paperAtIndexPath(indexPath)
        
        try! realm.write {
            realm.delete(paper)
        }
    }
    
}

// MARK: - Segues

extension PaperListViewModel
{
    func viewModelForNewPaper() -> PaperInformationViewModel
    {
        let paper = Paper()
        try! realm.write {
            realm.add(paper)
        }
        let viewModel = PaperInformationViewModel(paper: paper, isCreate: true)
        return viewModel
    }
    
    func viewModelForExistPaper(_ indexPath: IndexPath) -> PaperInformationViewModel
    {
        let paper = paperAtIndexPath(indexPath)
        let viewModel = PaperInformationViewModel(paper: paper, isCreate: false)
        return viewModel
    }
    
}

// MARK: private method

private extension PaperListViewModel
{
    func deleteFileAtURL(_ url: URL)
    {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error as NSError {
            print("deleteFileAtURL error: \(error.userInfo)")
        }
    }
}


