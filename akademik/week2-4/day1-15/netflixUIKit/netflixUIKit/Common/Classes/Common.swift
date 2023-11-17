//
//  Common.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/11/23.
//

import Foundation
import UIKit

class Common {
    
    static let shared = Common()
    
    /// Add subview to super window
    /// - Parameter window: a call back if super window is not nil
    func addViewToWindow(window: (UIWindow) -> Void) {
        let currentWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        if let activeWindow = currentWindow {
            window(activeWindow)
        }
    }

}

