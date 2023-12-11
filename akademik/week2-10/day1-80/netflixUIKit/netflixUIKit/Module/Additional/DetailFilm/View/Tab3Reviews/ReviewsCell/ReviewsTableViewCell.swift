//
//  ReviewsTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImgView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

