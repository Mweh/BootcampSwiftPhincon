//
//  ExtDate.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 21/11/23.
//

import Foundation

// MARK: -- Specific format the string

extension String {
    func formattedDate(format: String) -> String { // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format based on your actual date string format
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        } else {
            return self // Return the original string if date conversion fails
        }
    }
    
    func truncateToWords(_ count: Int) -> String { // truncate a string to a specified number of words
        let words = self.components(separatedBy: " ")
        let truncatedWords = Array(words.prefix(count))
        return truncatedWords.joined(separator: " ")
    }
    
}

// MARK: -- Extension for String to retrieve specific key from Info.plist

extension String {
    // look in class ConstantAPIStuff

    // Adds a computed property string below when used in other class.
    var apiKeyTMDB: String { getValueFromInfoPlist(for: self) }
    var tokenKeyTMDB: String { getValueFromInfoPlist(for: self) }
    var adBannerUnitID: String { getValueFromInfoPlist(for: self) }
    var testDeviceIdentifiers: String { getValueFromInfoPlist(for: self) }
    var adRewardedUnitID: String { getValueFromInfoPlist(for: self) }
    var geminiApiKey: String { getValueFromInfoPlist(for: self) }
    
    // MARK: - Helper Function
    
    private func getValueFromInfoPlist(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("\(key) not found in Info.plist")
        }
        return value
    }
}
