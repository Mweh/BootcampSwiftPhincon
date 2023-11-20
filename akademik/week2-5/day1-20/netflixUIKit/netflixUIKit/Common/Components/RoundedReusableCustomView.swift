//
//  RoundedReusableCustomView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/11/23.
//

import UIKit

class RoundedReusableCustomView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        roundedCorner()
        addShadow()
    }

    func roundedCorner() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }

    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 4, height: 4) // Adjusted offset for bottom right
        self.layer.shadowRadius = 6
    }

//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        layer.borderColor = UIColor.gray.cgColor
//        layer.borderWidth = borderWidth
//        layer.cornerRadius = cornerRadius
//        layer.shadowOpacity = 0.23
//        layer.shadowRadius = 7
//        layer.shadowOffset = .zero
//        layer.shadowColor = UIColor.gray.cgColor
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }

}
