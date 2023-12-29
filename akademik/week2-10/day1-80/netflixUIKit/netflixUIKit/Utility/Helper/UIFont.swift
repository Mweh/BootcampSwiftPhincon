//
//  UIFont.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 10/12/23.
//

// File: UIFont.swift

import Foundation
import UIKit

struct AppFontName {
    static let regular = "NetflixSans-Regular"
    static let bold = "NetflixSans-Bold"
    static let lightAlt = "NetflixSans-Light"
    static let nsctFontUIUsage = "NSCTFontUIUsageAttribute"
    static let uiFontDescriptor = "UIFontDescriptor"
}

// Customise font
extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: AppFontName.nsctFontUIUsage)
}

extension UIFont { // modify system Font to be customizable
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        if let customFont = UIFont(name: AppFontName.regular, size: size) {
            return customFont
        } else {
            // Fallback to system font or handle the error as needed
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        if let customFont = UIFont(name: AppFontName.bold, size: size) {
            return customFont
        } else {
            // Fallback to system font or handle the error as needed
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        if let customFont = UIFont(name: AppFontName.lightAlt, size: size) {
            return customFont
        } else {
            // Fallback to system font or handle the error as needed
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard let fontDescriptor = aDecoder.decodeObject(forKey: AppFontName.uiFontDescriptor) as? UIFontDescriptor,
              let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.lightAlt
        default:
            fontName = AppFontName.regular
        }
        
        if let customFont = UIFont(name: fontName, size: fontDescriptor.pointSize) {
            self.init(name: customFont.fontName, size: customFont.pointSize)!
        } else {
            // Fallback to system font or handle the error as needed
            self.init(myCoder: aDecoder)
        }
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
