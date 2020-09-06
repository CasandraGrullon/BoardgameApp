//
//  ActivityIndicator.swift
//  BoardgameApp
//
//  Created by casandra grullon on 9/6/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

extension UIViewController {
    func showActivityIndicator(loadingView: UIView, spinner: UIActivityIndicatorView ) {
        DispatchQueue.main.async {
            loadingView.addSubview(spinner)
            self.view.addSubview(loadingView)
            spinner.startAnimating()
        }
    }
    func hideActivityIndicator(loadingView: UIView, spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
}

