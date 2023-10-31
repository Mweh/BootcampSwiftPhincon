//
//  LoginViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        if let storedUser = getUser(), let enteredUsername = emailTextField.text, let enteredPassword = passwordTextField.text {
            if storedUser.0 == enteredUsername && storedUser.1 == enteredPassword {
                // Successful login
                // You can perform a segue to the main screen or show an alert
                let vc = MainTabBarViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Incorrect credentials
                // Show an error message
                print("email salah")
            }
        } else {
            // No stored user data
            // Show an error message
            let vc = MainTabBarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func saveUser(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func getUser() -> (String, String)? {
        if let username = UserDefaults.standard.string(forKey: "username"),
           let password = UserDefaults.standard.string(forKey: "password") {
            return (username, password)
        }
        return nil
    }
    
}
