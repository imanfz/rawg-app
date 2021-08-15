//
//  LoadingView.swift
//  RAWG
//
//  Created by Iman Faizal on 14/08/21.
//

import Foundation
import UIKit

func showSpinner(uiView : UIView) {
    var vSpinner: UIView?
    let spinnerView = UIView.init(frame: uiView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let indicatorView = UIActivityIndicatorView.init(style: .large)
    indicatorView.startAnimating()
    indicatorView.center = spinnerView.center
    
    DispatchQueue.main.async {
        spinnerView.addSubview(indicatorView)
        uiView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
}

func removeSpinner(uiView: UIView) {
    DispatchQueue.main.async {
        uiView.removeFromSuperview()
    }
}
