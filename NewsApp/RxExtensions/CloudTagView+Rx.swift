//
//  CloudTagView+Rx.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: CloudTagView {
    
    var items: Binder<[String]> {
        return Binder(self.base) { tagView, items in
            tagView.items = items
        }
    }
    
    var tagSelected: Driver<String> {
        return base.collectionView.rx.modelSelected(String.self)
                .asDriver(onErrorJustReturn: "")
    }
    
}
