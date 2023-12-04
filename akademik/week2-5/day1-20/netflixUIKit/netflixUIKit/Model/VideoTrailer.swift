//
//  VideoTrailer.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import Foundation

// MARK: - VideoTrailer
struct VideoTrailer: Codable {
    let id: Int?
    let results: [ResultVideoTrailer]?
}

// MARK: - Result
struct ResultVideoTrailer: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

