//
//  UILabel+Rx.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, size in
            let font = label.font.withSize(size)
            label.font = font
        }
    }
    
}
