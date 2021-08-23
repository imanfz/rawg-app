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
    
    var request = AF.request("https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4")
    
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
        request
            .validate()
            .responseDecodable(of: ListGameResponse.self) {(response) in
                guard let result = response.value else {return}
                
                if result.error == nil {
                    self.listGame = result.results
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.removeSpinner()
                } else {
                    print("Error = " + (result.error)!)
                }
            }
    }
}
