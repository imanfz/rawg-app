//
//  DetailViewController.swift
//  RAWG
//
//  Created by Iman Faizal on 07/08/21.
//

import UIKit
import Alamofire
import AXPhotoViewer

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblReleased: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ivWindows: UIImageView!
    @IBOutlet weak var ivPlaystation: UIImageView!
    @IBOutlet weak var ivXbox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblRatingTop: UILabel!
    @IBOutlet weak var lblListGenre: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    let apiUrl = "https://api.rawg.io/api/games"
    let apiKey = "e001986026694736a6d022e8d556abc4"
    
    var idGame: Int?
    var detailGame: DetailGameResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup toolbar
        viewWillAppear(true)

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
        
        // Get id game
        if let result = idGame {
            observeData(mId: result)
            ivPoster.isUserInteractionEnabled = true
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
            ivPoster.sd_setImage(with: imgUrl)
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
    }
}
