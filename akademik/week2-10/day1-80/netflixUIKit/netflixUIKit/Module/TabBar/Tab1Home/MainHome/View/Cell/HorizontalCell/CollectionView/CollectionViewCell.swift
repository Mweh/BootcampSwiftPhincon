//
//  CollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit
import SkeletonView

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var playImg: UIImageView!
    
    var isCircle = true 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = container.frame.height / 2
        container.clipsToBounds = true
        
        if let collectionView = superview as? UICollectionView,
           let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // Adjust the spacing for this cell
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }
    }


}
