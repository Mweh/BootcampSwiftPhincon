//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 01/12/23.
//

import Foundation
import UIKit

enum RefreshTextLabel{ // a label for pull down to refresh
    static func refreshTL() -> UILabel{
        let textLabel = UILabel()
        textLabel.text = "Pull to refresh"
        textLabel.textAlignment = .center
        textLabel.textColor = .systemRed
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        return textLabel
    }
}
