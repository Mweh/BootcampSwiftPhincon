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
    case getDiscoverTV
    case getUpcoming(page: Int)
    case searchMovie(query: String)
    case getFavoriteNoPaging
    case getFavorite(page: Int)
    case addFavorite(param: ParamAddFavorite)
    case getVideoTrailer(id: Int)
    case getCredits(id: Int)
    
    func path() -> String {
        switch self {
        case .getNowPlaying:
            return "movie/now_playing"
        case .getPopular:
            return "movie/popular"
        case .getTopRated:
            return "movie/top_rated"
        case .getDiscoverTV:
            return "discover/movie"
        case .getUpcoming:
            return "discover/movie?primary_release_date.gte=2023-11-23"
//        case .getUpcoming:
//            return "movie/upcoming"
        case .searchMovie:
            return "search/movie"
        case .getFavoriteNoPaging:
            return "account/20655384/favorite/movies"
        case .getFavorite:
            return "account/20655384/favorite/movies"
        case .addFavorite:
            return "account/20655384/favorite"
        case .getVideoTrailer(let id):
            return "movie/\(id)/videos"
        case .getCredits(let id):
            return "/movie/\(id)/credits"
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
        case .getNowPlaying, .getPopular, .getTopRated, .getDiscoverTV, .getFavoriteNoPaging, .getVideoTrailer, .getCredits:
            return nil
        case .getUpcoming(let page), .getFavorite(page: let page):
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
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "\(BaseConstant.tmdbTokenKey)"
        ]
        return params
    }
    
    func urlString() -> String {
        let basePath = BaseConstant.host + self.path()
        let separator = basePath.contains("?") ? "&" : "?"
        return basePath + separator + "api_key=" + BaseConstant.tmdbApiKey
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchMovie, .getUpcoming, .getFavorite, .getFavoriteNoPaging:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
}

class BaseConstant {
    static var host = "https://api.themoviedb.org/3/"
    static let tmdbApiKey = "TMDB_API_KEY".apiKeyTMDB
    static let tmdbTokenKey = "TMDB_TOKEN_KEY".tokenKeyTMDB
}
