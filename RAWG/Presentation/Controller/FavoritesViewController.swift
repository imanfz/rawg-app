//
//  FavoritesViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 25/08/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoData: UILabel!
    
    var listFavorite: [FavoriteModel] = []
    private lazy var favoriteProvider: DatabaseProvider = {
        return DatabaseProvider()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ItemRowGameTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "ItemRowGameTableViewCell")
    }
    
    private func loadData() {
        showSpinner(onView: self.view)
        self.favoriteProvider.getAllFavorite { result in
            DispatchQueue.main.async {
                self.removeSpinner()
                if result.isEmpty {
                    self.labelNoData.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.labelNoData.isHidden = true
                    self.tableView.isHidden = false
                    self.listFavorite = result
                    self.tableView.reloadData()
                }
            }
        }
    }
}
