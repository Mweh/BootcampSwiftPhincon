//
//  MovieDescriptionTableCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 03/11/23.
//
import Kingfisher
import SkeletonView // i want to implement this but doesnt work at the moment
import UIKit

class MovieDescriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStackViewIcon: UIStackView!
    @IBOutlet var imgView: UIImageView!
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
        imgView.layer.borderWidth = 2.0
        imgView.layer.borderColor = UIColor.white.cgColor
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
