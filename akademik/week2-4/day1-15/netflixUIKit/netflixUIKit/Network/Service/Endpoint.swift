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
    case getVideoTrailer(id: Int) // pls continue for this case like path etc below
    
    func path() -> String {
        switch self {
        case .getNowPlaying:
            return "movie/now_playing"
        case .getPopular:
            return "movie/popular"
        case .getTopRated:
            return "movie/top_rated"
        case .getDiscoverTV:
            return "discover/tv"
        case .getUpcoming:
            return "movie/upcoming"
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
        case .getNowPlaying, .getPopular, .getTopRated, .getDiscoverTV, .getFavoriteNoPaging, .getVideoTrailer:
            return nil
        case .getUpcoming(let page), .getFavorite(page: let page):
            return ["page": page]
        case .searchMovie(let query):
            return ["query": query]
        case .addFavorite(let param):
            return [
                "media_type": param.mediaType,
                "media_id": param.mediaId,
                "favorite": param.favorite            ]
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMDBlYzUzMzcwMWNhMWI5NjA2ODFkYjE5NTc3MDQ5NyIsInN1YiI6IjY1NDJmODlmZWQyYWMyMDBlM2M5NDZlOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0h72RSgCAlF8WP35k2NEgei9lyo37Btogq9DlO-56Gw"
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
    static let tmdbApiKey = "TMDB_API_KEY".apiKey
}
