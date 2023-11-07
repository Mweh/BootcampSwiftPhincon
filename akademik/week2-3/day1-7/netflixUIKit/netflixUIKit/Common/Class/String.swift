//
//  String.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 06/11/23.
//

import Foundation

extension String {
    var apiKey: String {
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("API key '\(self)' not found in Info.plist") //Thread 1: Fatal error: API key 'TMDB_API_KEY' not found in Info.plist
        }
        return value
    }
}
