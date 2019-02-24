//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities
import RxSwiftExt

class NewsViewModel {
    
    let results: Driver<[News]>
    let searchError: Driver<Error>
    let isSearchShown: PublishSubject<Bool>
    
    let isNewsShown: Driver<Bool>
    let searchQuery: Observable<String>
    
    let viewState: Driver<ViewState>
    let isViewStateHidden: Driver<Bool>
    let isLoading: Driver<Bool>
    
    let disposeBag = DisposeBag()
    
    init(input:
        (search: Driver<String>,
        recentSearchSelected: Driver<String>),
         newsRepository: NewsRepository,
         localStorage: LocalStorage) {
        
        let loadingIndicator = ActivityIndicator()
        self.isLoading = loadingIndicator
            .startWith(false)
            .asDriver()
        
        //search
        self.searchQuery = Observable.merge(
            input.search.asObservable(),
            input.recentSearchSelected.asObservable())
            .filter { !$0.isEmpty }
        
        let isSearchShown = PublishSubject<Bool>()
        self.isSearchShown = isSearchShown
        
        let searchResult = searchQuery
            .do(onNext: { search in
                isSearchShown.onNext(false)
                localStorage.addSearch(search)
            })
            .flatMapLatest { search in
                newsRepository.search(search)
                    .asObservable()
                    .retryWhenNeeded()
                    .trackActivity(loadingIndicator)
                    .materialize() //converts error and onNext to events
            }.share()
        
        self.results = searchResult
            .elements()
            .startWith([])
            .asDriver(onErrorJustReturn: [])
        
        self.searchError = searchResult
            .errors()
            .asDriver(onErrorJustReturn: NewsError())
        
        self.viewState = NewsViewModel.viewState(results: results, error: searchError, isLoading: isLoading)
        
        let searchShownDriver = isSearchShown.asDriver(onErrorJustReturn: false)
        
        //weather state view is hidden or shown
        self.isViewStateHidden = Driver
            .combineLatest(self.results,
                           searchShownDriver,
                           self.isLoading) { results, searchShown, isLoading in
                            if searchShown { return true }
                            if isLoading { return false }
                            if results.isEmpty { return false }
                            return true
            }
            .asDriver(onErrorJustReturn: false)
        
        self.isNewsShown = Driver.combineLatest(
            self.isViewStateHidden,
            searchShownDriver,
            self.isLoading) { viewStateHidden, searchShown, isLoading in
                if isLoading { return false }
                if searchShown { return false }
                if !viewStateHidden { return false}
                return true
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    class func viewState(results: Driver<[News]>, error: Driver<Error>, isLoading: Driver<Bool>) -> Driver<ViewState> {
        //view states
        let isEmpty = results
            .filter { $0.isEmpty }
            .skip(1) //to avoid catching the "startWith"
            .map { _ in return ViewState.empty }
        
        let error = error
            .withLatestFrom(results) { error, results -> ViewState in
                if !results.isEmpty {
                    return ViewState.errorWithContent(error)
                } else {
                    return ViewState.error(error)
                }
        }
        
        let loading = isLoading
            .filter { $0 == true }
            .map { _ in return ViewState.loading }
        
        return Driver.merge(isEmpty,
                            error,
                            loading)
            .startWith(.start)
            .asDriver(onErrorJustReturn: ViewState.error(NewsError()))
        
    }
}
