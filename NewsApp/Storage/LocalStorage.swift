//
//  LocalStorage.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalStorage: class {
    var lastSearch: Observable<[String]> { get }
    func addSearch(_ string: String)
    func clear()
}
