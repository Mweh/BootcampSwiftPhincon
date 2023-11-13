//
//  Constants.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

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
