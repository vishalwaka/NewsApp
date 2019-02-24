//
//  NewsService.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import RxSwift
import Moya

protocol NewsService {
    func search(_ query: String) -> Single<Response>
}
