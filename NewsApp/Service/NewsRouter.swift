//
//  NewsRouter.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Moya

enum NewsRouter {
    case search(String)
}

extension NewsRouter: TargetType {
    var baseURL: URL {
        return URL(string: NetworkingConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/everything"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let query):
            return ["q": query,
                    "apiKey": Constants.apiKey]
        }
    }
    
    var task: Task {
        if let `parameters` = parameters {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            let data = [
              "status": "ok",
              "totalResults": 5336,
              "articles": [
                [
                "source": [
                "id": "techcrunch",
                "name": "TechCrunch"
                ],
                "author": "Romain Dillet",
                "title": "Coinbase users can now withdraw Bitcoin SV following BCH fork",
                "description": "If you’re a Coinbase user, you may have seen some new tokens on your account. The Bitcoin Cash chain split into two different chains back in November. It means that if you held Bitcoin Cash on November 15, you became the lucky owner of Bitcoin SV and Bitcoin …",
                "url": "http://techcrunch.com/2019/02/15/coinbase-users-can-now-withdraw-bitcoin-sv-following-bch-fork/",
                "urlToImage": "https://techcrunch.com/wp-content/uploads/2017/08/bitcoin-split-2017a.jpg?w=711",
                "publishedAt": "2019-02-15T14:53:40Z",
                "content": "If youre a Coinbase user, you may have seen some new tokens on your account. The Bitcoin Cash chain split into two different chains back in November. It means that if you held Bitcoin Cash on November 15, you became the lucky owner of Bitcoin SV and Bitcoin A… [+1514 chars]"
                ]
            ]
            ] as [String: Any]
            return jsonSerializedUTF8(json: data)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
