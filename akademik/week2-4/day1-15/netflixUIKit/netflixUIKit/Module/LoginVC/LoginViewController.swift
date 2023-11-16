//
//  LoginViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import LocalAuthentication
import FirebaseAuth
import GoogleSignIn
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var customGSignInButton: GIDSignInButton!
    
    let vc = MainTabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let googleSignInButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleSignInPressed(_:)))
        customGSignInButton.addGestureRecognizer(googleSignInButtonTapGesture)
        changeRegisterLabel()
    }
    
    func changeRegisterLabel(){
        // Get the current title of the button
        guard let currentTitle = registerButton.title(for: .normal) else {
            return
        }
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: currentTitle)
        
        if let range = currentTitle.range(of: "Start") {
            // Apply the desired attributes to the specified range
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(range, in: currentTitle))
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSRange(range, in: currentTitle))
        }
        // Set the attributed string as the new title of the button
        registerButton.setAttributedTitle(attributedString, for: .normal)
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
    
    @IBAction func regularLoginPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Handle invalid input
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle login error
                self?.showAlert(title: "Login Error", message: error.localizedDescription)
                print("Login Error: \(error.localizedDescription)")
            } else {
                // Successful login
                self?.showAlert(title: "Success", message: "Login Successful", completion: {
                    self?.navigateToHome()
                })
            }
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToHome() {
        // Push to MainTabBarViewController
        let mainTabVC = MainTabBarViewController()
        self.navigationController?.pushViewController(mainTabVC, animated: true)
        // user: 1@a.com
        // pass: 123456
    }
    
    @IBAction func toRegisterVC(_ sender: Any) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}
