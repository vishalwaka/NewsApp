//
//  NewsServiceImpl.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class NewsServiceImpl: NewsService {
    
    let provider: MoyaProvider<NewsRouter>
    
    init(provider: MoyaProvider<NewsRouter>) {
        self.provider = provider
    }
    
    func search(_ query: String) -> Single<Response> {
        return self.provider.rx.request(.search(query))
    }
}
