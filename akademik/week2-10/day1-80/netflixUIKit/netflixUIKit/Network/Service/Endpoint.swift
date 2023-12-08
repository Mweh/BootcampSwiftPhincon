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
    case getSimilar(id: Int)
    case getReviews(id: Int)
    case getDetails(id: Int)
    
    func path() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())

        switch self {
        case .getNowPlaying:
            return "movie/now_playing?sort_by=popularity.desc&page=2"
        case .getPopular:
            return "movie/popular"
        case .getTopRated:
            return "movie/top_rated"
        case .getDiscoverTV:
            return "discover/movie"
        case .getUpcoming:
            return "discover/movie?primary_release_date.gte=\(currentDate)"
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
        case .getSimilar(let id):
            return "/movie/\(id)/similar"
        case .getReviews(let id):
            return "/movie/\(id)/reviews"
        case .getDetails(let id):
            return "/movie/\(id)"
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
        case .getNowPlaying, .getPopular, .getTopRated, .getDiscoverTV, .getFavoriteNoPaging, .getVideoTrailer, .getCredits, .getSimilar, .getReviews, .getDetails:
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
        case .searchMovie, .getUpcoming, .getFavorite, .getFavoriteNoPaging, .getSimilar, .getReviews, .getDetails:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
}
