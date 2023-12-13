//
//  DiscoverSort.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 13/12/23.
//
struct DiscoverSort: Codable {
    var sort_by: String
    
    enum CodingKeys: String, CodingKey {
        case sort_by
    }
    static let itemSort_by = [
        "primary_release_date.asc",
        "primary_release_date.desc",
        "vote_average.asc",
        "vote_average.desc",
        "vote_count.asc",
        "vote_count.desc",
        "popularity.asc",
        "popularity.desc",
        "revenue.asc",
        "revenue.desc"
    ]
}
