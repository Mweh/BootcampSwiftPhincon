//
//  MsFlixyModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/01/24.
//

import UIKit

// MARK: -- ChatMessage Model
struct ChatMessage: Codable {
    let text: String
    let isMsFlixy: Bool
    let timestamp: Date
    let imageData: Data?
    let isTypingLoading: Bool
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    init(text: String, isMsFlixy: Bool, image: UIImage? = nil, isTypingLoading: Bool = false) {
        self.text = text
        self.isMsFlixy = isMsFlixy
        self.timestamp = Date()
        self.imageData = image?.jpegData(compressionQuality: 0.8) // Convert UIImage to Data
        self.isTypingLoading = isTypingLoading
    }
}

enum InputMode {
    case text, image, speech
}

enum StateAI: Int { //isTyping
    case loading, isFinished, failed
}
