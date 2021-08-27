//
//  EditProfileViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 27/08/21.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var ivPhotos: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!

    private let imagePicker = UIImagePickerController()
    
    @IBAction func getImage(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
        if let photos = ivPhotos.image?.pngData(), let name = tfName.text, let email = tfEmail.text {
            if photos.isEmpty {
                textEmpty("Photos")
            } else if name.isEmpty {
                textEmpty("Name")
            } else if email.isEmpty {
                textEmpty("Email")
            } else {
                saveProfile(photos, name, email)
            }
        }
    }
    
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
        self.navigationItem.title = "Edit Profile"
        
        // set back button without text
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    private func setDataToUI() {
        ProfileModel.synchronize()
        ivPhotos.image = UIImage(data: ProfileModel.photos)
        ivPhotos.clipsToBounds = true
        tfName.text = ProfileModel.name
        tfEmail.text = ProfileModel.email
        
    }
    
    private func saveProfile(_ photos: Data, _ name: String, _ email: String) {
        ProfileModel.photos = photos
        ProfileModel.name = name
        ProfileModel.email = email
        
        let alert = UIAlertController(
            title: "Successful",
            message: "Profile updated.",
            preferredStyle: .alert)
                        
        alert.addAction(UIAlertAction(
            title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func textEmpty(_ field: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: "\(field) is empty",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setDataToUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
