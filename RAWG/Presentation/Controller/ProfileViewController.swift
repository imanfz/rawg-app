//
//  ProfileViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 15/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup toolbar
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.darkColor
        self.navigationController?.navigationBar
            .standardAppearance
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        self.navigationItem.title = "Profile"
        // set back button without text
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
