//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/12/23.
//

import Foundation
import UIKit

// MARK: - ConstantsLogin

struct ConstantsLogin {
    struct Titles {
        static let success = "Success"
        static let error = "Login Error"
        static let errorFaceId = "Invalid Biometric"
    }
    struct Messages {
        static let success = "\("Login Successful, Welcome"~) "
        static let successGoogle = "Google Sign-In Success"
        static let errorFaceId = "This app does not get permission for biometric"
    }
    static let dispatchFaceIdTime: DispatchTime = .now() + 1
    static let stringChangeLabel = "Start"
    static let sizeBoldFont: CGFloat = 20
}

// MARK: - Extension for Additional Functions

extension LoginViewModel {
    
    // Show alert utility function
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        AlertUtility.showAlert(from: navigationController, title: title, message: message, completion: completion)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension LoginCoordinator: UIViewControllerTransitioningDelegate {
    
    // Provide the custom presentation controller for the presented view controller
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

