//
//  News.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation

struct News: Decodable {
    
    let content: String?
    let urlToImage: String?
    let title: String?
    let author: String?
    let url: String?
    let publishedAt: String?
    let descriptionValue: String?
    
    init(content: String = "",
         urlToImage: String = "",
         title: String = "",
         author: String = "",
         url: String = "",
         publishedAt: String = "",
         descriptionValue: String = "") {
        self.content = content
        self.urlToImage = urlToImage
        self.title = title
        self.author = author
        self.url = url
        self.publishedAt = publishedAt
        self.descriptionValue = descriptionValue
    }
    
    enum CodingKeys: String, CodingKey {
        case content
        case urlToImage
        case title
        case author
        case url
        case publishedAt
        case descriptionValue = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        self.descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue) ?? ""
    }
}
