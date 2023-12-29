//
//  UIImage.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/12/23.
//

import UIKit
import Foundation

extension UIImage {
    // Resize the image to fit within the specified maxWidth and maxHeight
    func resizedTo(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        // Define the new size to constrain the image within
        let newSize = CGSize(width: maxWidth, height: maxHeight)
        
        // Calculate the ratio to maintain the aspect ratio of the original image
        let ratio = min(newSize.width / size.width, newSize.height / size.height)

        // Begin a new image context with the desired size and scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        
        // Draw the original image within the calculated bounds
        draw(in: CGRect(origin: .zero, size: CGSize(width: size.width * ratio, height: size.height * ratio)))
        
        // Get the resized image from the current image context
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the image context
        UIGraphicsEndImageContext()

        // Return the resized image if available, otherwise return the original image
        return resizedImage ?? self
    }
}
