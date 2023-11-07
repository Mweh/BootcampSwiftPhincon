//
//  MovieDescriptionTableCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 03/11/23.
//

import UIKit
import Kingfisher

class MovieDescriptionTableCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet var loremLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(data: ResultUpcoming?) {
        if let validData = data {
            seasonLabel.text = "Popularity: \(validData.popularity)"
            titileLabel.text = validData.title
            loremLabel.text = validData.overview
            genreLabel.text = validData.releaseDate
        }
    }
    
}
