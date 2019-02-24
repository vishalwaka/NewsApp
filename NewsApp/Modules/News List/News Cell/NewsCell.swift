//
//  NewsCell.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import UIKit
import Reusable
import RxKingfisher

class NewsCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    
    var viewModel = NewsItemViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupBindings()
        self.backgroundColor = .clear
    }
    
    func bind(_ news: News) {
        self.viewModel.bind(news)
    }
    
    func setupBindings() {
        self.viewModel.text
            .drive(newsTitleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.imageUrlString.asObservable()
            .map { URL(string: $0) }
            .bind(to: backgroundImage.kf.rx.image())
            .disposed(by: rx.disposeBag)
        self.viewModel.newsTime
            .drive(publishedAtLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}
