//
//  UIViewController+ActivityIndicator.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 22/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresenter {
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.color = .black
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.activityIndicator.center = CGPoint(x:self.view.bounds.size.width / 2, y:self.view.bounds.size.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
