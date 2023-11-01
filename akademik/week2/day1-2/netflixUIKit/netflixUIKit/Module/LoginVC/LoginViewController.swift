//
//  LoginViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let vc = MainTabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(googleSignInPressed(_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func googleSignInPressed(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            print("Google Sign-In Success")
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
