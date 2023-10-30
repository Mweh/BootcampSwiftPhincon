//
//  CollectionCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Kingfisher
import UIKit

class VerticalCell: UITableViewCell {


    
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var myListLabel: UIButton!
    @IBOutlet weak var playLabel: UIButton!
    @IBOutlet weak var infoLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let url = URL(string: "https://tinyurl.com/yebdyfnd") {
            imageMovie.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
