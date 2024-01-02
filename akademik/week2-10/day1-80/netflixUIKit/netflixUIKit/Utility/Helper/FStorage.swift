//
//  FStorage.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 01/12/23.
//

import FirebaseStorage
import Foundation

// Enum to encapsulate Firebase Storage operations
enum FStorage {
    
    // Firebase Storage instance
    static let storage = Storage.storage()
    
    // Uploads an image to the specified path in Firebase Storage
    static func uploadImage(_ image: UIImage, toPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Reference to the storage path
        let storageRef = storage.reference().child(path)
        
        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "FStorage", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])
            completion(.failure(error))
            return
        }
        
        // Metadata for the uploaded file
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload task to Firebase Storage
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                // Handle upload failure
                completion(.failure(error!))
                return
            }
            
            // Retrieve download URL after successful upload
            storageRef.downloadURL { url, error in
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(error ?? NSError()))
                    return
                }
                
                // Provide download URL in the completion block
                completion(.success(downloadURL))
            }
        }
        
        // Observe and print upload progress
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload progress: \(percentComplete)%")
        }
        
        // Observe upload success (no specific action for success in this example)
        uploadTask.observe(.success) { snapshot in
        }
        
        // Observe upload failure and handle errors
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                completion(.failure(error))
            }
        }
    }
    
    // Retrieves an image from Firebase Storage at the specified path
    static func getImage(atPath path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Reference to the storage path
        let storageRef = storage.reference().child(path)
        
        // Download image data from Firebase Storage
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Handle download failure
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                // Provide UIImage in the completion block
                completion(.success(image))
            } else {
                // Unknown error if neither data nor image is available
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image data."])
                completion(.failure(unknownError))
            }
        }
    }
    
    // Retrieves the download URL of an image from Firebase Storage at the specified path
    static func getImageURL(atPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Reference to the storage path
        let storageRef = storage.reference().child(path)
        
        // Retrieve download URL from Firebase Storage
        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle URL retrieval failure
                completion(.failure(error))
            } else if let downloadURL = url?.absoluteString {
                // Provide download URL in the completion block
                completion(.success(downloadURL))
            } else {
                // Unknown error if download URL is not available
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image URL."])
                completion(.failure(unknownError))
            }
        }
    }
}

