//
//  SquareCollectionViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 06/11/23.
//

import Lottie
import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ratedNumberLabel: UILabel!
    @IBOutlet weak var containerNewMovie: UIView!
    @IBOutlet weak var tagTop10Img: UIImageView!
    @IBOutlet weak var lottieView: LottieAnimationView! //it's not connected to this????
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = container.frame.height / 20
        imgView.layer.cornerRadius = imgView.frame.height / 20
        imgView.clipsToBounds = true
        containerNewMovie.makeRounded(20)
        container.clipsToBounds = true
        
        addStrokeToLabel()
        
    }
    func addFireAnimtion() {
        lottieView.animation = LottieAnimation.named("fireAnimation")
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        lottieView.frame = container.bounds
        container.addSubview(lottieView)
        lottieView.play()
    }


    func addStrokeToLabel(){
        // Set up stroke attributes
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white, // Set the stroke color
            .foregroundColor: UIColor.black, // Set the text color
            .strokeWidth: -2.0, // Set the stroke width
        ]
        
        // Create an NSAttributedString with the stroke attributes
        let attributedString = NSAttributedString(string: ratedNumberLabel.text ?? "", attributes: strokeTextAttributes)
        
        // Assign the attributed string to the label
        ratedNumberLabel.attributedText = attributedString
    }
}
