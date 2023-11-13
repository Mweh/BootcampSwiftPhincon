//
//  Endpoint.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation
import Alamofire

struct ParamAddFavorite {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
}

enum Endpoint {
    case getNowPlaying
    case getPopular
    case getTopRated
    case addFavorite(param: ParamAddFavorite)
    case getUpcoming(page: Int)
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
        case .addFavorite:
            return "/addfavorite"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .addFavorite:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getNowPlaying, .getPopular, .getTopRated, .getDiscoverTV:
            return nil
        case .getUpcoming(let page):
            return ["page": page]
        case .searchMovie(let query):
            return ["query": query]
        case .addFavorite(let param):
            return [
                "media_type": param.mediaType,
                "media_id": param.mediaId,
                "favorite": param.favorite
            ]
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return params
    }
    
    func urlString() -> String {
        return BaseConstant.host + self.path() + "?api_key=\(BaseConstant.tmdbApiKey)" // found the error, should put & here
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case.searchMovie, .getUpcoming:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
}

class BaseConstant {
    static var host = "https://api.themoviedb.org/3/"
    static let tmdbApiKey = "TMDB_API_KEY".apiKey
}
