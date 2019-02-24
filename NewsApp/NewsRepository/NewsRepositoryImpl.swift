//
//  NewsRepositoryImpl.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class NewsRepositoryImpl: NewsRepository {
    
    let service: NewsService
    
    init(service: NewsService) {
        self.service = service
    }
    
    func search(_ query: String) -> Single<[News]> {
        return self.service.search(query)
            .map(SearchResponse.self)
            .map { $0.articles }
    }
}
