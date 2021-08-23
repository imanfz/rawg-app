//
//  Extension.swift
//  RAWG
//
//  Created by Iman Faizal on 14/08/21.
//

import Foundation
import SDWebImage

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemRowGameTableViewCell", for: indexPath) as? ItemRowGameTableViewCell {
            
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
