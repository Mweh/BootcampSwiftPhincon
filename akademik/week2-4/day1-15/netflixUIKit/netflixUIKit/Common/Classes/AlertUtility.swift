//
//  AlertUtility.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/11/23.
//

import UIKit

class AlertUtility {
    static func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
