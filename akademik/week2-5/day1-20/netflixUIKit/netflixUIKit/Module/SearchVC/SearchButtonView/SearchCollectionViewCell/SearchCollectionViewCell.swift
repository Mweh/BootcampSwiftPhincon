//
//  SearchCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/11/23.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeImageRounded(10)
        // Initialization code
    }

}
