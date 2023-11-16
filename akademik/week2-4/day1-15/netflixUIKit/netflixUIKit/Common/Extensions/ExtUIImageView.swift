//
//  Extensions.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/11/23.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded(_ totalDivide: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / totalDivide
        self.clipsToBounds = true
    }
}

