//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import RxSwift
import Moya

protocol NewsRepository: class {
    func search(_ query: String) -> Single<[News]>
}

struct NewsError: LocalizedError {
    let message: String
    
    init(message: String = "Something went wrong.") {
        self.message = message
    }
    
    var errorDescription: String? {
        return self.message
    }
}
