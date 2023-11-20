//
//  ExtUIView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/11/23.
//

import Foundation
import UIKit

extension UIView {
    func makeCornerRadius(_ radius: CGFloat, maskedCorner: CACornerMask? = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }
    
    
    func addBorderLine(width: CGFloat = 1,
                       color: UIColor = .blue) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - thickness, width: self.frame.size.width+40, height: thickness)
        self.layer.addSublayer(border)
    }
    
    func addShadow(color: UIColor = .separator,
                   offset: CGSize = CGSize(width: 0, height: 3),
                   opacity: Float = 0.5,
                   radius: CGFloat = 2,
                   path: UIBezierPath? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = path?.cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    
}

extension UIView {
    func makeRounded(_ totalDivide: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / totalDivide
        self.clipsToBounds = true
    }
}
