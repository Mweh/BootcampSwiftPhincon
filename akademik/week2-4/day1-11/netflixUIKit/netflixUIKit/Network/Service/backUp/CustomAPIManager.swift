//
//  CustomAPIManager.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation

final class CustomAPIManager {
    static let shared = CustomAPIManager()
    private init() {}
    
    enum APIError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func fetchRequest<T: Codable>(endpoint: Endpoint, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(endpoint: endpoint) else {
            completion(.failure(APIError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func request(endpoint: Endpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.urlString()) else {
            return nil  // Return nil if the URL is not valid
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method()
        
        return request
    }
    
}

//
//import Foundation
//import Alamofire
//
//class NetworkManager: NSObject {
//    static let shared = NetworkManager()
//    private override init() {}
//
//    func makeAPICall<T: Decodable>(endpoint: Endpoint,
//                                   completion: @escaping(Result<T, Error>) -> Void) {
//        AF.request(endpoint.urlString(),
//                   method: endpoint.methode(),
//                   parameters: endpoint.parameters,
//                   encoding: JSONEncoding.default,
//                   headers: endpoint.headers).validate().responseDecodable(of: T.self) { (response) in
//
//            guard let item = response.value else {
//                completion(.failure(response.error as! Error))
//                return
//            }
//            completion(.success(item))
//        }
//
//    }
//
//}
