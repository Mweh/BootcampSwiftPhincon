//
//  SquareCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 06/11/23.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = container.frame.height / 20
        container.clipsToBounds = true
    }
}
