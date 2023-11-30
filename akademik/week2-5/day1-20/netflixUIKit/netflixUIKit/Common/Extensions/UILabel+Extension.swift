//
//  ExtUILabel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 20/11/23.
//

import UIKit

extension UILabel {
    func setSystemSymbol(_ symbolName: String, withAdditionalText additionalText: String? = nil) {
        // Create a system symbol image with the label's tint color
        guard let symbolImage = UIImage(systemName: symbolName)?.withTintColor(UIColor.secondaryLabel) else {
            return
            // or self.tintColor
        }
        
        // Create an attachment with the symbol image
        let attachment = NSTextAttachment()
        attachment.image = symbolImage
        
        // Create an attributed string with the attachment
        let attributedString = NSAttributedString(attachment: attachment)
        
        // Append additional text if provided
        let fullString = NSMutableAttributedString()
        fullString.append(attributedString)
        
        if let additionalText = additionalText {
            fullString.append(NSAttributedString(string: " \(additionalText)"))
        }
        
        // Set the attributed string to the label
        self.attributedText = fullString
    }
    
    func setSystemSymbolWithFormattedDate(_ symbolName: String, date: String?, format: String = "MMM d, yyyy") {
        guard let releaseDate = date else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format based on your data
        
        if let date = dateFormatter.date(from: releaseDate) {
            let formattedDateFormatter = DateFormatter()
            formattedDateFormatter.dateFormat = format
            let formattedDate = formattedDateFormatter.string(from: date)
            self.setSystemSymbol(symbolName, withAdditionalText: formattedDate)
        }
    }
    
    func animateCounting(to targetValue: Int, duration: TimeInterval = 1.0, systemName: String? = nil, suffix: String = "") {
        guard targetValue > 0 else {
            // Do nothing if the target value is not positive
            return
        }

        var startValue = 0
        let animationSteps = targetValue <= 100 ? 10 : 100
        let stepSize = targetValue / animationSteps

        // Create a Timer to update the label's text
        Timer.scheduledTimer(withTimeInterval: duration / Double(animationSteps), repeats: true) { timer in
            startValue += stepSize
            self.setSystemSymbol(systemName ?? "", withAdditionalText: "\(startValue) \(suffix)")

            if startValue >= targetValue {
                // Stop the timer when the target value is reached
                timer.invalidate()
                self.setSystemSymbol(systemName ?? "", withAdditionalText: "\(targetValue) \(suffix)")
            }
        }
    }
    
}
