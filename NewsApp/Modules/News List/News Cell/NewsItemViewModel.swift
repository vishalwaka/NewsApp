//
//  NewsItemViewModel.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewsItemViewModel {
    
    let news: PublishSubject<News>
    
    let text: Driver<String>
    let imageUrlString: Driver<String>
    let newsTime: Driver<String>
    
    init() {
        self.news = PublishSubject<News>()
        
        self.text = self.news
            .map { $0.title ?? "" }
            .asDriver(onErrorJustReturn: "")
        self.imageUrlString = self.news
            .map { $0.urlToImage ?? ""}
            .asDriver(onErrorJustReturn: "")
        self.newsTime = self.news
            .map { ($0.publishedAt ?? "").getReadableDateFromString() ?? "" }
            .asDriver(onErrorJustReturn: "")
    }
    
    func bind(_ news: News) {
        self.news.onNext(news)
    }
    
}
