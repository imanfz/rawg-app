//
//  DetailViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 07/08/21.
//

import UIKit
import Alamofire
import AlamofireImage
import AXPhotoViewer
import Toaster

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblReleased: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblRatingTop: UILabel!
    @IBOutlet weak var lblListGenre: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var btnFavorites: UIImageView!
    
    private let apiUrl = "https://api.rawg.io/api/games"
    private let apiKey = "e001986026694736a6d022e8d556abc4"
    
    private lazy var databaseProvider: DatabaseProvider = {
        return DatabaseProvider()
    }()
    
    var idGame: Int?
    var detailGame: DetailGameResponse?
    private var favoriteState: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.darkColor
        self.navigationController?
            .navigationBar
            .standardAppearance
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        self.navigationItem.title = "Detail"
        
        // set button share
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_share"),
            style: .plain,
            target: self,
            action: #selector(shareButtonClicked)
        )
        
        // set back button without text
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        // setup Toast
        configureAppearance()
        configureAccessibility()
        
        // Get id game
        if let result = idGame {
            observeData(mId: result)
            checkStateFavorite()
            btnFavorites.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToFavorite)))
        }
    }
    
    @objc func openImage() {
        let photos = [AXPhoto(image: ivPoster.image)]
        let dataSource = AXPhotosDataSource(photos: photos)
        let photosViewController = AXPhotosViewController(dataSource: dataSource)
        photosViewController.modalPresentationStyle = .overFullScreen
        self.present(photosViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func shareButtonClicked(sender: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        var textToShare = ""
        if let urlGame = detailGame?.website {
            textToShare = urlGame
        }

        if let myWebsite = URL(string: textToShare) {
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = [
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.addToReadingList
            ]

            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
            activityVC.popoverPresentationController?.backgroundColor = UIColor.darkColor
        }
    }

    private func observeData(mId: Int) {
        showSpinner(onView: self.view)
        scrollView.isHidden = true
        let url = apiUrl + "/" + mId.string + "?key=" + apiKey
        
        AF.request(url)
            .responseDecodable(of: DetailGameResponse.self) { response in
                switch (response.result) {
                case .success(let value):
                    self.removeSpinner()
                    if value.error == nil {
                        self.detailGame = value
                        self.setDataToUI()
                        self.scrollView.isHidden = false
                    } else {
                        print("Error = " + (value.error)!)
                    }
                case .failure(let error):
                    self.removeSpinner()
                    if error._code == NSURLErrorTimedOut {
                        print("Error: Request time out")
                    } else {
                        print("Error:: \(error)")
                    }
            }
        }
    }
    
    private func setDataToUI() {
        lblTitle.text = detailGame?.name
        if let imgUrl = URL(string: (detailGame?.backgroundImage?.string) ?? "") {
            ivPoster.af.setImage(
                withURL: imgUrl,
                placeholderImage: UIImage(systemName: "photo.fill"))
            ivPoster.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImage)))
        }
        if let genres = detailGame?.genres {
            for index in genres.indices {
                if let name = genres[index].name {
                    if index == 0 {
                        lblListGenre.text = name
                    } else {
                        lblListGenre.text! += ", " + name
                    }
                }
            }
        }
        
        lblOverview.text = detailGame?.description
        if let top = detailGame?.ratingTop {
            lblRatingTop.text = "Top " + top.string
        }
        
        
        if let date = detailGame?.released {
            lblReleased.text = date.toDate()?.toString()
        }
        
        setImageFavoriteState()
    }
    
    private func configureAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .lightGray
        appearance.textColor = .black
        appearance.font = .systemFont(ofSize: 14)
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.bottomOffsetPortrait = 24
        appearance.cornerRadius = 20
        appearance.maxWidthRatio = 0.7
    }

    private func configureAccessibility() {
        ToastCenter.default.isSupportAccessibility = true
    }
    
    private func setImageFavoriteState() {
        if favoriteState == 1 {
            btnFavorites.image = UIImage(systemName: "heart.fill")
        } else {
            btnFavorites.image = UIImage(systemName: "heart")
        }
    }
    
    private func checkStateFavorite() {
        databaseProvider.checkFavoritesById(idGame!) { result in
            DispatchQueue.main.async {
                if result {
                    self.favoriteState = 1
                } else {
                    self.favoriteState = 0
                }
            }
        }
    }
    
    @objc func addToFavorite() {
        if favoriteState == 0 {
            databaseProvider.addFavorites(
                (detailGame?.id)!,
                (detailGame?.name)!,
                (detailGame?.backgroundImage)!,
                (detailGame?.released)!,
                (detailGame?.rating)!,
                (detailGame?.ratingTop)!) {
                DispatchQueue.main.async {
                    Toast(text: "Successfuly add to favorite", duration: Delay.long).show()
                    self.favoriteState = 1
                    self.setImageFavoriteState()
                }
            }
        } else {
            databaseProvider.removeFavorite((detailGame?.id)!) {
                DispatchQueue.main.async {
                    Toast(text: "Successful remove from favorite", duration: Delay.long).show()
                    self.favoriteState = 0
                    self.setImageFavoriteState()
                }
            }
        }
    }
}
