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
    
    let API_KEY = "e001986026694736a6d022e8d556abc4"
    
    let urlListGame = "https://api.rawg.io/api/games?key="

    var game = [Game]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.showSpinner(onView: self.view)
        tableView.isHidden = true
        
        let view = UIView()
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        //button.setTitle("Profile", for: .normal)
        button.addTarget(self, action: #selector(ProfileButtonClicked(sender:)), for: .touchDown)
        button.sizeToFit()
        view.addSubview(button)
        view.frame = button.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    @objc func ProfileButtonClicked(sender: UIBarButtonItem) {
//        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            
        // Push/mendorong view controller lain
//        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
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
