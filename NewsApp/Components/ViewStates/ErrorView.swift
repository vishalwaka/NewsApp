//
//  ErrorView.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import UIKit

class ErrorView: UIView, StateSubview {
    
    private var didSetupViews: Bool = false
    
    var errorMessage: String = "Error!" {
        didSet {
            self.label.text = errorMessage
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.text = "Error!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }
    
    func show() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }
    
    private func setupViews() {
        if !didSetupViews {
            self.didSetupViews = true
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        self.addSubview(label)
        
        label.prepareForConstraints()
        label.pinLeft(20)
        label.centerHorizontally()
        label.centerVertically()
    }
    
}
