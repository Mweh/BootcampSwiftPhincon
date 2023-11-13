//
//  Endpoint.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation
import Alamofire

enum Endpoint {
    case getNowPlaying
    case getPopular
    case getTopRated
    case getUpcoming
    case getDiscoverTV
    case searchMovie(query: String)
    
    func path() -> String {
        switch self {
        case .getNowPlaying:
            return "movie/now_playing"
        case .getPopular:
            return "movie/popular"
        case .getTopRated:
            return "movie/top_rated"
        case .getUpcoming:
            return "movie/upcoming"
        case .getDiscoverTV:
            return "discover/tv"
        case .searchMovie:
            return "search/movie"
        }
    }
    
    func method() -> HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getNowPlaying, .getPopular, .getTopRated, .getUpcoming, .getDiscoverTV: //Switch must be exhaustive
            return nil
        case .searchMovie(let query):
            return ["query": query]
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return params
    }
    
    func urlString() -> String {
        return BaseConstant.host + self.path() + "?api_key=\(BaseConstant.tmdbApiKey)"
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case.searchMovie:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
}

class BaseConstant {
    static var host = "https://api.themoviedb.org/3/"
    static let tmdbApiKey = "TMDB_API_KEY".apiKey
}
