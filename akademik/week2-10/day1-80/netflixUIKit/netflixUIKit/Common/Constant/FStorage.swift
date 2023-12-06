//
//  FStorage.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 01/12/23.
//

import FirebaseStorage
import Foundation

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
