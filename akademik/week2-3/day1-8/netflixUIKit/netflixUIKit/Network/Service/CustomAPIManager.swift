//
//  CustomAPIManager.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation
import Alamofire

class CustomAPIManager: NSObject {
    static let shared = CustomAPIManager()
    override init() {}
    
    func makeAPICall<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        var headers = endpoint.headers
        
        // Add the API key to the headers
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).validate().responseDecodable(of: T.self) { (response) in
            
            guard let item = response.value else {
                completion(.failure(response.error as! Error))
                return
            }
            completion(.success(item))
        }
    }
    
}

