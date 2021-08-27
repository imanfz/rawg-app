//
//  ProfileViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 15/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var ivPhotos: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // setup toolbar
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.darkColor
        self.navigationController?.navigationBar
            .standardAppearance
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        self.navigationItem.title = "Profile"
        
        // set button share
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_edit"),
            style: .plain,
            target: self,
            action: #selector(editProfile)
        )
        
        // set back button without text
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        loadDetail()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func loadDetail() {
        ProfileModel.synchronize()
        self.ivPhotos.image = UIImage(data: ProfileModel.photos)
        self.ivPhotos.clipsToBounds = true
        self.lblFullname.text = ProfileModel.name
        self.lblEmail.text = ProfileModel.email
    }
    
    @objc func editProfile() {
        let edit = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)

        // Push/mendorong view controller lain
        self.navigationController?
            .pushViewController(edit, animated: true)
    }
}
