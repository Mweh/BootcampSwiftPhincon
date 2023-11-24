//
//  PhotoLibraryManager.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 23/11/23.
//

import Photos

class PhotoLibraryManager {
    
    static func saveImageToPhotosLibrary(imageURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
            request?.creationDate = Date()
        }) { (success, error) in
            if success {
                print("Image saved to Photos library successfully.")
            } else {
                print("Error saving image to Photos library: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    static func saveImageToPhotos(url: URL, completion: @escaping (Error?) -> Void) {
        // Download the image from the URL
        guard let imageData = try? Data(contentsOf: url) else {
            completion(NSError(domain: "InvalidImageData", code: 0, userInfo: nil))
            return
        }

        // Save the image to the Photos library
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }) { (success, error) in
            if success {
                completion(nil)
            } else if let error = error {
                completion(error)
            } else {
                completion(NSError(domain: "UnknownError", code: 0, userInfo: nil))
            }
        }
    }
}
