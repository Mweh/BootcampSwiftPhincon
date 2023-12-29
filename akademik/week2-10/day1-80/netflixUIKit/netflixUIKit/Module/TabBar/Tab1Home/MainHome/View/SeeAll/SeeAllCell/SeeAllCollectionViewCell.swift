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
        imgView.makeAllRounded(devidedBy: 10)
    }
    
    func setup(imageName: String) {
        let tmdbImgBase = TMDBImageURL.url(size: .w342)
        let urlString = "\(tmdbImgBase)\(imageName)"
        let url = URL(string: urlString)
        imgView.kf.setImage(with: url)
    }

}
