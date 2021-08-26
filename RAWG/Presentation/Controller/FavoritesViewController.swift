//
//  FavoritesViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 25/08/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listGame: [Game]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup toolbar
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.darkColor
        self.navigationController?.navigationBar
            .standardAppearance
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        self.navigationItem.title = "My Favorite"
        // set back button without text
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ItemRowGameTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "ItemRowGameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func getData() {
        
    }
}
