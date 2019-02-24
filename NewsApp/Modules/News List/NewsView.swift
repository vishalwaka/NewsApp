//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Swinject
import Reusable

class NewsView: UIViewController {
    
    var viewModel: NewsViewModel!
    let newsRepository: NewsRepository
    let localStorage: LocalStorage
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var searchContainer: UIView!
    let searchView: SearchView
    var stateView: StateView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(searchView: SearchView, repository: NewsRepository, localStorage: LocalStorage) {
        self.newsRepository = repository
        self.searchView = searchView
        self.localStorage = localStorage
        super.init(nibName: String(describing: NewsView.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupBindings()
    }
    
}

extension NewsView {
    
    func setupViewModel() {
        self.viewModel = NewsViewModel(
            input: (search: self.headerView.search,
                    recentSearchSelected: self.searchView.recentSearchSelected),
            newsRepository: self.newsRepository,
            localStorage: localStorage)
    }
    
    func configureViews() {
        self.tableView.contentInset.top = self.headerView.maxHeight
        self.tableView.register(cellType: NewsCell.self)
        self.tableView.backgroundColor = .clear
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = false
        self.configureSearchView()
        self.configureStateView()
    }
    
    func setupBindings() {
        
        self.viewModel.results
            .drive(tableView.rx
                .items(cellIdentifier: "NewsCell",
                       cellType: NewsCell.self)) { _, element, cell in
                        cell.bind(element)
            }.disposed(by: rx.disposeBag)
        
        self.viewModel.isNewsShown
            .drive(onNext: { [weak self] shown in
                self?.animateTableView(shown: shown)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.searchQuery
            .bind(to: self.headerView.searchTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.viewState
            .drive(self.stateView.rx.state)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.isViewStateHidden
            .drive(self.stateView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        self.tableView.rx.contentOffset
            .map { $0.y }
            .map { ($0 + self.headerView.maxHeight) / (self.headerView.minHeight + self.headerView.maxHeight) }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.headerView.rx.fractionComplete)
            .disposed(by: rx.disposeBag)
        
        self.headerView.searchTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.viewModel.isSearchShown.onNext(true)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.isSearchShown
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] show in
                self?.searchContainer.isHidden = !show
                if show {
                    self?.headerView.collapse()
                    self?.searchView.showAnimated()
                } else {
                    self?.headerView.expand()
                    self?.view.endEditing(true)
                }
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    func animateTableView(shown: Bool) {
        UIView.animate(withDuration: 0.2) {
            if shown {
                self.tableView.alpha = 1.0
            } else {
                self.tableView.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func configureSearchView() {
        self.searchContainer.addSubview(searchView.view)
        self.addChild(self.searchView)
        self.searchView.view.prepareForConstraints()
        self.searchView.view.pinEdgesToSuperview()
    }
    
    func configureStateView() {
        self.stateView = StateView()
        self.stateView.isUserInteractionEnabled = false
        self.view.addSubview(stateView)
        stateView.prepareForConstraints()
        stateView.pinEdgesToSuperview()
    }
}
