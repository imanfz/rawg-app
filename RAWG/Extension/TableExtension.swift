//
//  Extension.swift
//  RAWG
//
//  Created by Iman Faizal on 14/08/21.
//

import UIKit
import AlamofireImage

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemRowGameTableViewCell", for: indexPath) as? ItemRowGameTableViewCell {
            
            let game = self.listGame?[indexPath.row]
            
            if let imgUrl = URL(string: (game?.backgroundImage)!) {
                cell.ivPoster.af.setImage(
                    withURL: imgUrl,
                    placeholderImage: UIImage(systemName: "photo.fill"))
                
                // set top round corner image view
                cell.ivPoster.layer.cornerRadius = 10
                cell.ivPoster.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            
            cell.lblTitle.text = game?.name
            cell.lblRating.text = game?.rating?.string

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
            
        // Mengirim id game
        detail.idGame = listGame?[indexPath.row].id
            
        // Push/mendorong view controller lain
        self.navigationController?
            .pushViewController(detail, animated: true)
    }
    
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemRowGameTableViewCell", for: indexPath) as? ItemRowGameTableViewCell {
            
            let game = self.listFavorite[indexPath.row]
            
            if let imgUrl = URL(string: (game.backgroundImage) ?? "") {
                cell.ivPoster.af.setImage(
                    withURL: imgUrl,
                    placeholderImage: UIImage(systemName: "photo.fill"))
                
                // set top round corner image view
                cell.ivPoster.layer.cornerRadius = 10
                cell.ivPoster.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            
            cell.lblTitle.text = game.name
            cell.lblRating.text = game.rating?.string

            if let top = game.ratingTop {
                cell.lblRatingTop.text = "Top " + top.string
            }
            
            if let date = game.released {
                cell.lblReleased.text = date.toDate()?.toString()
            }
            
            // set color if selected
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)

        // Mengirim id game
        detail.idGame = listFavorite[indexPath.row].id

        // Push/mendorong view controller lain
        self.navigationController?
            .pushViewController(detail, animated: true)
    }
}
