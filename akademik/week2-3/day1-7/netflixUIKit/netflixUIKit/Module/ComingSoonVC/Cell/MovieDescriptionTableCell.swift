//
//  MovieDescriptionTableCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 03/11/23.
//

import UIKit
import Kingfisher

class MovieDescriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStackViewIcon: UIStackView!
    @IBOutlet var imgView: UIImageView! // how to add black stroke/border
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet var loremLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    
    override func awakeFromNib() {
        containerStyle()
        super.awakeFromNib()
        selectionStyle = .none
        imgView.layer.cornerRadius = imgView.frame.height / 10
    }
    
    func containerStyle(){
        containerStackViewIcon.layer.cornerRadius = containerStackViewIcon.frame.height / 10
        imgView.layer.borderWidth = 2.0  // Adjust the width as needed
        imgView.layer.borderColor = UIColor.white.cgColor  // Set the border color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(data: ResultUpcoming?) {
        if let validData = data {
            seasonLabel.text = "Popularity: \(validData.popularity)"
            titileLabel.text = validData.title
            loremLabel.text = validData.overview
            loremLabel.sizeToFit()
            genreLabel.text = validData.releaseDate
        }
    }
    
}
