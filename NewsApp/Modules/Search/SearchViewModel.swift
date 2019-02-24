//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import RxSwiftUtilities

class SearchViewModel {
    
    let recentSearch: Driver<[String]>
    let isRecentSearchHidden: Driver<Bool>
    
    let isLoading: Driver<Bool>
    
    let disposeBag = DisposeBag()
    
    init(newsRepository: NewsRepository,
         localStorage: LocalStorage) {
        
        let loadingIndicator = ActivityIndicator()
        self.isLoading = loadingIndicator.asDriver()
        
        self.recentSearch = localStorage
            .lastSearch
            .asDriver(onErrorJustReturn: [])
        
        self.isRecentSearchHidden = self.recentSearch
            .map { $0.count == 0 }
            .startWith(true)
    }
}
