//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/12/23.
//

import UIKit

class LoginCoordinator: NSObject {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    let mainTabVC = MainTabBarController()
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation Methods
    
    // Navigate to the main tab view controller
    func navigateToHome() {
        navigationController.pushViewController(mainTabVC, animated: true)
    }
    
    // Navigate to the registration view controller
    func navigateToRegister() {
        let registerVC = RegisterViewController()
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    // Present the forgot password view controller as a custom modal
    func presentForgotPassword() {
        let forgotVC = ForgotPassViewController()
        forgotVC.modalPresentationStyle = .custom
        forgotVC.transitioningDelegate = self
        
        // Present the forgot password view controller
        navigationController.present(forgotVC, animated: true, completion: nil)
        
        // Add swipe down gesture for dismissal
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissHalfModal))
        swipeDown.direction = .down
        forgotVC.view.addGestureRecognizer(swipeDown)
    }
    
    // Dismiss the custom modal view controller
    @objc func dismissHalfModal() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
