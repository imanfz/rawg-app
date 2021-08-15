//
//  Extension.swift
//  RAWG
//
//  Created by Iman Faizal on 14/08/21.
//

import Foundation
import UIKit
import SDWebImage

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
}

extension Date {
    
    func toString(withFormat format: String = "d MMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemRowGameTableViewCell", for: indexPath) as? ItemRowGameTableViewCell {
            
            let game = self.listGame?[indexPath.row]
            
            if let imgUrl = URL(string: (game?.backgroundImage) ?? "") {
                cell.ivPoster.sd_setImage(with: imgUrl)
            }
            
            cell.lblTitle.text = game?.name
            cell.lblRating.text = game?.rating?.string
            
            // set top round corner image view
            cell.ivPoster.layer.cornerRadius = 10
            cell.ivPoster.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

            if let top = game?.ratingTop {
                cell.lblRatingTop.text = "Top " + top.string
            }
            
            if let date = game?.released {
                cell.lblReleased.text = date.toDate()?.toString()
            }
            
            // set color if selected
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
            
        // Mengirim id game
        detail.idGame = listGame?[indexPath.row].id
            
        // Push/mendorong view controller lain
        self.navigationController?
            .pushViewController(detail, animated: true)
    }
    
}

var vSpinner : UIView?

// loading view
extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        let indicatorView = UIActivityIndicatorView.init(style: .large)
        indicatorView.startAnimating()
        indicatorView.color = UIColor.white
        indicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
    }
    
}
