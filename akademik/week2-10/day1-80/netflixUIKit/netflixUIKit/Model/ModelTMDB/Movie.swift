//
//  Movie.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 06/11/23.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let dates: Dates?
    let page: Int
    var results: [ResultMovie]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - ResultMovie
struct ResultMovie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]
    var id: Int
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String
    let popularity: Double
    let releaseDate: String?
    let posterPath: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
