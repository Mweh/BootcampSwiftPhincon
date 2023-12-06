//
//  TappableMovieView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 24/11/23.
//

import UIKit

protocol Tappable {
    func didTap()
}

class TappableFadedImageView: FadedImageView, UIGestureRecognizerDelegate {
    
    var tapDelegate: Tappable?
    
    convenience init() {
        self.init(frame: .zero)
        setupTapGesture()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTapGesture()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }

    @objc private func handleTap() {
        tapDelegate?.didTap()
    }
}
