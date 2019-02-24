//
//  SearchResponse.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    let totalResults: Int
    let articles: [News]
}
