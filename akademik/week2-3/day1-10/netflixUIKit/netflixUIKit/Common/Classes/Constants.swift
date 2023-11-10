//
//  Constants.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Foundation
import UIKit

enum SFSymbol {
    static let homeSymbol = UIImage(systemName: "house")
    static let searchSymbol = UIImage(systemName: "magnifyingglass")
    static let comingSoonSymbol = UIImage(systemName: "play.rectangle.on.rectangle")
    static let downloadsSymbol = UIImage(systemName: "square.and.arrow.down")
    static let moreSymbol = UIImage(systemName: "line.3.horizontal")
    
    func listCircle(_ number: Int) -> String {
        "\(number).circle"
    }
}
