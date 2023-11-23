//
//  CastingCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import UIKit

class CastingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var actorImgView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actorImgView.layer.cornerRadius = 50
        actorImgView.clipsToBounds = true
    }

}
