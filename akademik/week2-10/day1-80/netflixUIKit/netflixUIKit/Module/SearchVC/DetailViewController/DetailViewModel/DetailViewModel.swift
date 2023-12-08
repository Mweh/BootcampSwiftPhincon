//
//  DetailViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 21/11/23.
//

import Foundation
import UIKit

class DetailViewModel {
    private var data: ResultMovie?
    
    init(data: ResultMovie) {
        self.data = data
    }
    
    var title: String {
        return data?.title ?? ""
    }
    
    var backdropURL: URL? {
        guard let backdropPath = data?.backdropPath else { return nil }
        let tmdbImgBase = TMDBImageURL.url(size: .w500)
        return URL(string: "\(tmdbImgBase)\(backdropPath)")
    }
    
    var posterURL: URL? {
        guard let posterPath = data?.posterPath else { return nil }
        let tmdbImgBase = TMDBImageURL.url(size: .w300)
        return URL(string: "\(tmdbImgBase)\(posterPath)")
    }
    
    var voteAverage: NSAttributedString {
        guard let voteAverage = data?.voteAverage else {
            return NSAttributedString(string: "")
        }
        let voteAverageText = String(format: "%.1f", voteAverage)
        return NSAttributedString(string: voteAverageText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
    }
    
    var releaseYear: String {
        return data?.releaseDate?.formattedDate(format: "yyyy") ?? ""
    }
    
    var popularityText: String {
        return "\(data?.popularity ?? 0)"
    }
    
    var voteCountText: String {
        return "\(data?.voteCount ?? 0)"
    }
    
    // Other properties and methods as needed
}
