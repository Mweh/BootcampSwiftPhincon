//
//  CollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit
import ViewAnimator

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/2)

    var isCircle = true // Initially, it's a circle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = container.frame.height / 2
        container.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        toggleShape()

    }
    
    func toggleShape(){
        if isCircle {
            // Change to square with animation using ViewAnimator
            container.layer.cornerRadius = container.frame.height
            UIView.animate(views: [self], animations: [rotateAnimation], duration: 0.3)
            container.transform = transform
            isCircle = false
        } else {
            // Change back to circle with animation using ViewAnimator
            container.layer.cornerRadius = container.frame.height / 2
            UIView.animate(views: [self], animations: [rotateAnimation])
            container.transform = transform
            isCircle = true
        }
    }
    
}
