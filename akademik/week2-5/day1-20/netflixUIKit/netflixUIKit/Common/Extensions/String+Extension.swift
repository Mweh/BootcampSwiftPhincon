//
//  ExtDate.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 21/11/23.
//

import Foundation

extension String {
    func formattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format based on your actual date string format
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        } else {
            return self // Return the original string if date conversion fails
        }
    }
    
    func truncateToWords(_ count: Int) -> String {
        let words = self.components(separatedBy: " ")
        let truncatedWords = Array(words.prefix(count))
        return truncatedWords.joined(separator: " ")
    }
    
}
