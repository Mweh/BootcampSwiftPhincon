//
//  CarouselCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/11/23.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.makeAllRounded(devidedBy: 5)
    }
}
