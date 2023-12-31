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
    case addFavorite(param: ParamAddFavorite) // POST BDOY
    case getVideoTrailer(id: Int)
    case getCredits(id: Int)
    case getSimilar(id: Int)
    case getReviews(id: Int)
    case getDetails(id: Int)
    case discoverSort(sort_by: String)
    
    func path() -> String {
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            
            return "discover/movie?primary_release_date.gte=\(currentDate)"
        case .searchMovie:
            return "search/movie"
        case .getFavoriteNoPaging:
            return "account/20655384/favorite/movies"
        case .getFavorite:
            return "account/20655384/favorite/movies"
        case .addFavorite: // POST BDOY
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
        case .discoverSort(let sort_by):
            return "/discover/movie?sort_by=\(sort_by)"
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
        case .getNowPlaying, .getPopular, .getTopRated, .getDiscoverTV, .getFavoriteNoPaging, .getVideoTrailer, .getCredits, .getSimilar, .getReviews, .getDetails, .discoverSort: // PARAM GET
            return nil
        case .getUpcoming(let page), .getFavorite(page: let page):
            return ["page": page]
        case .searchMovie(let query):
            return ["query": query]
        case .addFavorite(let param):
            return [
                "media_type": param.mediaType,
                "media_id": param.mediaId,
                "favorite": param.favorite // BODY POST
            ]
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "\(ConstantAPIStuff.tmdbTokenKey)"
        ]
        return params
    }
    
    func urlString() -> String {
        let basePath = ConstantAPIStuff.host + self.path()
        let separator = basePath.contains("?") ? "&" : "?"
        return basePath + separator + "api_key=" + ConstantAPIStuff.tmdbApiKey
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchMovie, .getUpcoming, .getFavorite, .getFavoriteNoPaging, .getSimilar, .getReviews, .getDetails, .discoverSort:
            return URLEncoding.queryString // Usually for param(GET)
        default: return JSONEncoding.default // Usually for body(POST)
        }
    }
}
