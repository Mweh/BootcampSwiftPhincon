//
//  CustomAPIManager.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation
import Alamofire

class CustomAPIManager: NSObject {
    // Singleton instance
    // The singleton pattern ensures that a class has only one instance and provides a global point of access to that instance.
    static let shared = CustomAPIManager()

    // Private initializer to enforce singleton pattern
    // The initializer is marked as private, preventing external code from creating new instances of CustomAPIManager. This ensures that the only instance of the class is the one provided by the shared property.
    private override init() {}

    // MARK: - Generic API Call

    func makeAPICall<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let headers = endpoint.headers
        
        // Add the API key to the headers
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: headers).validate().responseDecodable(of: T.self) { (response) in
            
            guard let item = response.value else {
                completion(.failure(response.error!))
                return
            }
            completion(.success(item))
        }
    }
    
    // MARK: - Add to Favorites API Call

    func addToFavorites(param: ParamAddFavorite, completion: @escaping (Result<Favorites, Error>) -> Void) {
        let endpoint = Endpoint.addFavorite(param: param)
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers).validate().responseDecodable(of: Favorites.self) { response in
            
            switch response.result {
            case .success(let favorites):
                completion(.success(favorites))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Download Image API Call

    func downloadImage(imageURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(imageURL, to: destination).validate().response { response in
            
            switch response.result {
            case .success(let url):
                completion(.success(url!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
