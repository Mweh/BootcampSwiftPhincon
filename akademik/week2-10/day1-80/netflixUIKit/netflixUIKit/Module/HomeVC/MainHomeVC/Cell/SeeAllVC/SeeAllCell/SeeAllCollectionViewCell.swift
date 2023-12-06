//
//  SeeAllCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/11/23.
//

import UIKit
import Kingfisher

class SeeAllCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.makeImageRounded(10)
    }
    
    func setup(imageName: String) {
        let urlString = "https://image.tmdb.org/t/p/w500/\(imageName)"
        let url = URL(string: urlString)
        imgView.kf.setImage(with: url)
    }

}
