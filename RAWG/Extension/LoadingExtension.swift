//
//  LoadingExtension.swift
//  RAWG
//
//  Created by Iman Faizal on 24/08/21.
//

import Foundation
import UIKit

var vSpinner: UIView?

// loading view
extension UIViewController {
    
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        let indicatorView = UIActivityIndicatorView.init(style: .large)
        indicatorView.startAnimating()
        indicatorView.color = UIColor.white
        indicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
}
