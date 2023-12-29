//
//  FadedImageView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 21/11/23.
//

import UIKit

@IBDesignable // add faded to UIImageView
class FadedImageView: UIImageView {

    private let gradientLayer = CAGradientLayer()

    // MARK: - Inspectable Properties

    @IBInspectable var fadeHeight: CGFloat = 50.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var fadeColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayer()
    }

    // MARK: - Private Methods

    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, fadeColor.cgColor]
        layer.mask = gradientLayer
    }

    private func updateGradientLayer() {
        gradientLayer.frame = bounds
        gradientLayer.locations = [NSNumber(value: Float(1.0 - (fadeHeight / bounds.height))), 1.0]
    }
}
