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

extension String {
    var apiKeyTMDB: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("API key '\(self)' not found in Info.plist")
        }
        return value
    }
    var tokenKeyTMDB: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("Token key '\(self)' not found in Info.plist")
        }
        return value
    }
    var adBannerUnitID: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("adBannerUnitID '\(self)' not found in Info.plist")
        }
        return value
    }
    var testDeviceIdentifiers: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("testDeviceIdentifiers '\(self)' not found in Info.plist")
        }
        return value
    }
    var adRewardedUnitID: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("adRewardedUnitID '\(self)' not found in Info.plist")
        }
        return value
    }
    var geminiApiKey: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("geminiApiKey '\(self)' not found in Info.plist")
        }
        return value
    }
}
