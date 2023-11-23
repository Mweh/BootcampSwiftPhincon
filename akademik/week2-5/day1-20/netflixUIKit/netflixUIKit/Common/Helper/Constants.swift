//
//  Constants.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import FirebaseStorage
import Foundation
import UIKit

enum SFSymbol {
    static let homeSymbol = UIImage(systemName: "house.circle")
    static let searchSymbol = UIImage(systemName: "magnifyingglass.circle")
    static let comingSoonSymbol = UIImage(systemName: "play.rectangle.on.rectangle.circle")
    static let moreSymbol = UIImage(systemName: "line.3.horizontal.circle")
    
    static let homeFillSymbol = UIImage(systemName: "house.circle.fill")
    static let searchFillSymbol = UIImage(systemName: "magnifyingglass.circle.fill")
    static let comingFillSoonSymbol = UIImage(systemName: "play.rectangle.on.rectangle.circle.fill")
    static let moreFillSymbol = UIImage(systemName: "line.3.horizontal.circle.fill")
}

enum RefreshTextLabel{
    static func refreshTL() -> UILabel{
        let textLabel = UILabel()
        textLabel.text = "Pull to refresh"
        textLabel.textAlignment = .center
        textLabel.textColor = .systemRed
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        return textLabel
    }
}

enum FStorage {
    static let storage = Storage.storage()
    
    static func uploadImage(_ image: UIImage, toPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "FStorage", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])
            completion(.failure(error))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(error ?? NSError()))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload progress: \(percentComplete)%")
        }
        
        uploadTask.observe(.success) { snapshot in
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                completion(.failure(error))
            }
        }
    }
    
    static func getImage(atPath path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image data."])
                completion(.failure(unknownError))
            }
        }
    }
    
    static func getImageURL(atPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        storageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let downloadURL = url?.absoluteString {
                completion(.success(downloadURL))
            } else {
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image URL."])
                completion(.failure(unknownError))
            }
        }
    }
}
