//
//  ExtUILabel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 20/11/23.
//

import UIKit

extension UILabel {
    func setSystemSymbol(_ symbolName: String, withColor symbolColor: UIColor = UIColor.secondaryLabel, withAdditionalText additionalText: String? = nil) {
        // Create a system symbol image with the specified color
        guard let symbolImage = UIImage(systemName: symbolName)?.withTintColor(symbolColor) else {
            return
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
    
    func animateCountingHour(to targetValue: Int, duration: TimeInterval = 1.0, systemName: String? = nil, suffix: String? = nil) {
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
            
            let hours = startValue / 60
            let minutes = startValue % 60
            
            let formattedText: String
            if hours > 0 {
                formattedText = "\(hours)h\(minutes)m"
            } else {
                formattedText = "\(minutes)m"
            }
            
            self.setSystemSymbol(systemName ?? "", withAdditionalText: formattedText + (suffix ?? ""))
            
            if startValue >= targetValue {
                // Stop the timer when the target value is reached
                timer.invalidate()
                
                let finalHours = targetValue / 60
                let finalMinutes = targetValue % 60
                
                let finalFormattedText: String
                if finalHours > 0 {
                    finalFormattedText = "\(finalHours)h\(finalMinutes)m"
                } else {
                    finalFormattedText = "\(finalMinutes)m"
                }
                
                self.setSystemSymbol(systemName ?? "", withAdditionalText: finalFormattedText + (suffix ?? ""))
            }
        }
    }
    
}
