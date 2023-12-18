//
//  UIImage.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/12/23.
//

import UIKit
import Foundation

extension UIImage {
    func resizedTo(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        let newSize = CGSize(width: maxWidth, height: maxHeight)
        let ratio = min(newSize.width / size.width, newSize.height / size.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: CGSize(width: size.width * ratio, height: size.height * ratio)))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage ?? self
    }
}
