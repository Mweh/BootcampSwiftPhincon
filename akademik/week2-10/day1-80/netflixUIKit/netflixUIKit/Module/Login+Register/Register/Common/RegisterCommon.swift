//
//  RegisterCommon.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 28/12/23.
//

import Foundation

struct ConstantsRegister {
    
    struct String {
        static let successTitle = "Success"
        static let successMessage = "Registration successful"
        static let errorTitle = "Error"
        static let errorMessage = "Please enter both email and password."
        static let registrationSuccessTemplate = "Registration successful. Please use %@ to log in."
        static let registerFailedMessage = "Registration failed: %@"
        
        static let naviTitle = "Register"
        static let fullTextTerm = "By creating an account or signing you agree to our Terms and Conditions"
        static let trimTextTerm = "Terms and Conditions"
    }
    
    struct Int {
        static let fontSize: CGFloat = 15
        static let minimumScaleFactor: CGFloat = 0.5
    }
}
