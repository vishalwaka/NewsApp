//
//  Observable+Retry.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import Moya

public extension Observable {

    public func retryWhenNeeded() -> Observable<Element> {
        return self
            .retry(
                
                .exponentialDelayed(maxCount: 3, initial: 4, multiplier: 2), shouldRetry: {error in
                    guard let moyaError = error as? MoyaError else {
                        return false
                    }
                    if case let .underlying(error, _) = moyaError {
                        let error = (error as NSError)
                        //Connection error
                        if error.domain == NSURLErrorDomain || 500...599 ~= error.code {
                            #if DEBUG
                                print("💔 retrying...")
                            #endif
                            return true
                        }
                    }
                    return false
        })
    }
}
