//
//  ViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 06/06/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var buttonBarProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private let url = URL(string: "https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4")
    
    var listGame: [Game]?
    private var loadingSpinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // setup toolbar
        buttonBarProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonProfile)))
        buttonBarProfile.isUserInteractionEnabled = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ItemRowGameTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "ItemRowGameTableViewCell")
    }
    
    @objc func buttonProfile() {
        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            
        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // fetch data
        observeData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeSpinner()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func observeData() {
        showSpinner(onView: self.view)
        tableView.isHidden = true
        AF.request(
            "https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4"
        ).validate().responseDecodable(of: ListGameResponse.self) { response in
            switch (response.result) {
            case .success(let value):
                self.tableView.isHidden = false
                self.removeSpinner()
                if value.error == nil {
                    self.listGame = value.results
                    self.tableView.reloadData()
                } else {
                    print("Error = " + (value.error)!)
                }
            case .failure(let error):
                self.tableView.isHidden = false
                self.removeSpinner()
                if error._code == NSURLErrorTimedOut {
                    print("Error: Request time out")
                } else {
                    print("Error:: \(error)")
                }
            }
        }
    }
}
