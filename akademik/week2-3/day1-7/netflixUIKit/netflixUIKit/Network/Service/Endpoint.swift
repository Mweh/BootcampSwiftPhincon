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
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .getNowPlaying, .getPopular, .getTopRated, .getUpcoming, .getDiscoverTV:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getNowPlaying, .getPopular, .getTopRated, .getUpcoming, .getDiscoverTV:
            return nil
        }
    }
    
    
    var headers: HTTPHeaders {
        switch self {
        case .getNowPlaying, .getPopular, .getTopRated, .getUpcoming, .getDiscoverTV:
            let params: HTTPHeaders = [
                "Content-Type": "Application/json"]
            return params
        }
    }
    
    func urlString() -> String {
        return BaseConstant.host + self.path() + "?api_key=\(BaseConstant.tmdbApiKey)"
    }
}

class BaseConstant {
    static var host = "https://api.themoviedb.org/3/"
    //    static let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    static let tmdbApiKey = "TMDB_API_KEY".apiKey
    
}

// You can access the API key using the environment variable

