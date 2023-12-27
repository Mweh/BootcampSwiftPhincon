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
        // Use URLSession to download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Dispatch the following operations to a background queue
            DispatchQueue.global(qos: .background).async {
                if let error = error {
                    // If there's an error during the download, notify on the main queue
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
                }

                guard let imageData = data else {
                    // If there's no data, notify about invalid image data on the main queue
                    DispatchQueue.main.async {
                        completion(NSError(domain: "InvalidImageData", code: 0, userInfo: nil))
                    }
                    return
                }

                // Save the image to the Photos library
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }) { (success, error) in
                    // Notify about the result on the main queue
                    DispatchQueue.main.async {
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
        }

        // Start the URLSession data task
        task.resume()
    }
    
}
