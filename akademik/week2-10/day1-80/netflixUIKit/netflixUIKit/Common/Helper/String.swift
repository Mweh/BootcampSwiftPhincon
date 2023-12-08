//
//  String.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 06/11/23.
//

import Foundation

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
}
