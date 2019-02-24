//
//  SearchView.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class SearchView: UIViewController {
    
    @IBOutlet weak var recentSearchCloudView: CloudTagView!
    
    var viewModel: SearchViewModel!
    let newsRepository: NewsRepository
    let localStorage: LocalStorage
    
    var recentSearchSelected: Driver<String>!
    
    init(newsRepository: NewsRepository,
         localStorage: LocalStorage) {
        self.newsRepository = newsRepository
        self.localStorage = localStorage
        super.init(nibName: String(describing: SearchView.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.setupBindings()
    }
    
}

extension SearchView {
    
    func setupViewModel() {
        self.viewModel = SearchViewModel(
            newsRepository: self.newsRepository,
            localStorage: self.localStorage)
    }
    
    func setupBindings() {
        
        self.recentSearchSelected = self.recentSearchCloudView.rx.tagSelected
        
        self.viewModel.recentSearch
            .drive(self.recentSearchCloudView.rx.items)
            .disposed(by: rx.disposeBag)
    }
}

//Animations
extension SearchView {
    func showAnimated() {
        self.recentSearchCloudView.alpha = 0.0
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            self.recentSearchCloudView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
