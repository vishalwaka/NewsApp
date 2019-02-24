//
//  DefaultContainer.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import Swinject
import Moya

final class DefaultContainer {
    
    let container: Container
    
    init() {
        self.container = Container()
        self.registerServices()
        self.registerViews()
        self.registerStorage()
    }
    
}

//Register Views
extension DefaultContainer {
    
    func registerViews() {
        
        self.container.register(SearchView.self) { resolver in
            SearchView(newsRepository: resolver.resolve(NewsRepository.self)!,
                       localStorage: resolver.resolve(LocalStorage.self)!)
        }
        
        self.container.register(NewsView.self) { resolver in
            NewsView(searchView: resolver.resolve(SearchView.self)!,
                     repository: resolver.resolve(NewsRepository.self)!,
                     localStorage: resolver.resolve(LocalStorage.self)!)
        }
    }
    
}

//Register Services
extension DefaultContainer {
    
    func registerServices() {
        self.container.register(NewsService.self) { _ in
            let provider = MoyaProvider<NewsRouter>(plugins: self.getDefaultPlugins())
            return NewsServiceImpl(provider: provider)
        }
        
        self.container.register(NewsRepository.self) { resolver in
            NewsRepositoryImpl(
                service: resolver.resolve(NewsService.self)!
            )
        }
    }
    
    func getDefaultPlugins() -> [PluginType] {
        #if DEBUG
        return [NetworkLoggerPlugin(verbose: true)]
        #else
        return []
        #endif
    }
    
}

//Register Storage
extension DefaultContainer {
    
    func registerStorage() {
        
        self.container.register(LocalStorage.self) { _ in
            return LocalStorageImpl()
        }
        
    }
    
}
