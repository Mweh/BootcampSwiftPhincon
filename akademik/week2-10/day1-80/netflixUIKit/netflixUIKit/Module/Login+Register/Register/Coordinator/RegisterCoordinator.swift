//
//  RegisterCoordinator.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 28/12/23.
//

import UIKit

class RegisterCoordinator{
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToWebViewController(){
        let vc = GoToWebViewController()
        
        vc.urlString = URLs.netflixTermsOfUse
        vc.modalPresentationStyle = .pageSheet
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func popNaviToLogin(){
        navigationController.popViewController(animated: true)
    }
}
