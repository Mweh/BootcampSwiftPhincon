//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 12/12/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ThemeManager {
    static let currentTintColorRelay = BehaviorRelay<UIColor>(value: .systemRed)
}
