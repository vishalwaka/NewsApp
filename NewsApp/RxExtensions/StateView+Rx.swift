//
//  StateView+Rx.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: StateView {
    
    var state: Binder<ViewState> {
        return Binder(self.base) { stateView, state in
            stateView.state = state
        }
    }
    
}
