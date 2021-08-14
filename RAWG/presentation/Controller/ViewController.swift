//
//  ViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 06/06/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var vSpinner: UIView?
    
    var request = AF.request("https://api.rawg.io/api/games?key=e001986026694736a6d022e8d556abc4")
    
    var listGame: [Game]?
    var loadingSpinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.showSpinner(onView: self.view)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName:"ItemRowGameTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "ItemRowGameTableViewCell")
        observeData()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func observeData() {
        tableView.isHidden = true
        request
            .validate()
            .responseDecodable(of: ListGameResponse.self) {(response) in
                guard let result = response.value else {return}
                self.listGame = result.results
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.removeSpinner()
            }
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicatorView = UIActivityIndicatorView.init(style: .large)
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
