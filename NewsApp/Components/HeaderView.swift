//
//  HeaderView.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HeaderView: UIView {
    
    let maxHeight: CGFloat = 160
    let minHeight: CGFloat = 72
    
    var heightConstraint: NSLayoutConstraint!
    
    var search: Driver<String>!
    
    var fractionComplete: CGFloat = 0.0 {
        didSet {
            self.animator?.fractionComplete = fractionComplete
        }
    }
    
    private var animator: UIViewPropertyAnimator?
    private var expandAnimator: UIViewPropertyAnimator?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: self.maxHeight)
    }
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Search News"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        textField.layer.cornerRadius = 6.0
        textField.textColor = .darkGray
        textField.tintColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.clearsOnBeginEditing = true
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        return button
    }()
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.setupConstraints()
        
        self.searchTextField.setPadding(14)
        
        self.setupAnimator()
        self.setupBindings()
    }
    
    private func setupBindings() {
        let editingDidEnd = self.searchTextField.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
        
        let searchTap = self.searchButton.rx
            .tap
            .asObservable()
        
        self.search = Observable.merge(editingDidEnd, searchTap)
            .withLatestFrom(self.searchTextField.rx.text.asObservable())
            .unwrap()
            .asDriver(onErrorJustReturn: "")
    }
    
    func collapse() {
        self.animator?.startAnimation()
    }
    
    func expand() {
        //figure out a way to do this animated
        self.fractionComplete = 0.0
    }
    
    private func setupAnimator() {
        
        var topPadding: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            if let bla = UIApplication.shared.delegate!.window {
                topPadding = bla?.safeAreaInsets.top ?? 0.0
            }
            
        }
        
        self.animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear, animations: {
            self.heightConstraint.constant = self.minHeight + topPadding
            self.logoLabel.alpha = 0
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        })
        
        self.animator?.pausesOnCompletion = true
        
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.blurView)
        self.addSubview(self.searchTextField)
        self.addSubview(self.searchButton)
        self.addSubview(self.bottomLine)
        self.addSubview(self.logoLabel)
        
        self.blurView.prepareForConstraints()
        self.searchTextField.prepareForConstraints()
        self.searchButton.prepareForConstraints()
        self.bottomLine.prepareForConstraints()
        self.logoLabel.prepareForConstraints()
        
        self.blurView.pinEdgesToSuperview()
        
        self.logoLabel.pinLeft(30.0)
        self.logoLabel.pinBottom(50.0)
        self.logoLabel.pinRight(140.0)
        
        self.searchTextField.pinLeft(30.0)
        self.searchTextField.pinRight(30.0)
        self.searchTextField.pinBottom(12.0)
        self.searchTextField.constraintHeight(36.0)
        
        self.searchButton.pinBottom(18.0)
        self.searchButton.pinRight(36.0)
        self.searchButton.constraintHeight(20.0)
        self.searchButton.constraintWidth(20.0)
        
        self.bottomLine.constraintHeight(1)
        self.bottomLine.pinRight()
        self.bottomLine.pinLeft()
        self.bottomLine.pinBottom()
        
        var topPadding: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            if let bla = UIApplication.shared.delegate!.window {
                topPadding = bla?.safeAreaInsets.top ?? 0.0
            }
            
        }
        
        self.heightConstraint = self.constraintHeight(self.maxHeight + topPadding)
        
        self.layoutIfNeeded()
        
    }
    
}
