//
//  ViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 06/06/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var buttonBarProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let url = URL(string: "https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4")
    
    var listGame: [Game]?
    var loadingSpinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup toolbar
        viewWillDisappear(true)
        
        buttonBarProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonProfile)))
        buttonBarProfile.isUserInteractionEnabled = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ItemRowGameTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "ItemRowGameTableViewCell")
        
        // fetch data
        observeData()
    }
    
    @objc func buttonProfile() {
        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            
        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func observeData() {
        showSpinner(onView: self.view)
        tableView.isHidden = true
        AF.request(
            "https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4"
        ).responseDecodable(of: ListGameResponse.self) { response in
            switch (response.result) {
            case .success(let value):
                if value.error == nil {
                    self.listGame = value.results
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    print("Error = " + (value.error)!)
                }
                self.removeSpinner()
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    print("Error: Request time out")
                } else {
                    print("Error:: \(error)")
                }
                self.removeSpinner()
            }
        }
    }
}
