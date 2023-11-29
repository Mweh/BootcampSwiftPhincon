//
//  SimilarCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 29/11/23.
//

import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.makeImageRounded(10)
    }

}
