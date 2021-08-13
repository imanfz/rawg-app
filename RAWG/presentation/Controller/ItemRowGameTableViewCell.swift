//
//  ItemRowGameTableViewCell.swift
//  RAWG
//
//  Created by Iman Faizal on 13/08/21.
//

import UIKit

class ItemRowGameTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var ivWindows: UIImageView!
    @IBOutlet weak var ivPlaystation: UIImageView!
    @IBOutlet weak var ivXbox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
