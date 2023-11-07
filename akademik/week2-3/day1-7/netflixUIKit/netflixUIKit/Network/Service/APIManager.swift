////
////  TMDBService.swift
////  netflixUIKit
////
////  Created by Muhammad Fahmi on 02/11/23.
////
//
//import Foundation
//import Alamofire
//
//class APIManager {
//
//    static func fetchPopularMovies(completion: @escaping (Result<Popular, Error>) -> Void) {
////        let apiKey = "a00ec533701ca1b960681db195770497" // Replace with your TMDB API key
//        let baseUrl = "https://api.themoviedb.org/3/movie/popular"
//        
//        let parameters: [String: Any] = [
//            "api_key": BaseConstant.tmdbApiKey
//        ]
//        
//        AF.request(baseUrl, method: .get, parameters: parameters).responseDecodable(of: Popular.self) { response in
//            switch response.result {
//            case .success(let popular):
//                completion(.success(popular))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
