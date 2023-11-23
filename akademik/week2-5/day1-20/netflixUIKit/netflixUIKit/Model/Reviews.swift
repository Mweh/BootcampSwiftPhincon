//
//  Reviews.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import Foundation

// MARK: - Reviews
struct Reviews: Codable {
    let id, page: Int
    let results: [ResultReviews]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ResultReviews: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
