//
//  TMDBImageURL.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 29/11/23.
//

import Foundation

enum ImageSize: String, CaseIterable {
    case w45, w92, w154, w185, w200, w300, w342, w500, w632, w780, w1280, original
}

enum TMDBImageURL {
    static func url(size: ImageSize) -> String {
        let baseUrl = "https://image.tmdb.org/t/p/"
        return "\(baseUrl)\(size.rawValue)/"
    }
}
