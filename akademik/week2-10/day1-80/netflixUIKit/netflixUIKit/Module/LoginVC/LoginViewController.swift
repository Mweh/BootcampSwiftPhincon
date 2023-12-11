//
//  LoginViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import FirebaseAuth
import GoogleSignIn
import LocalAuthentication
import RxSwift
import RxCocoa
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var regularLoginButton: UIButton!
    @IBOutlet weak var customGSignInButton: GIDSignInButton!
    @IBOutlet weak var faceIdButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var logInAnonymouslyButton: UIButton!
    
    private let faceID = FaceID()
    private let disposeBag = DisposeBag()
    private let vc = MainTabBarViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        performGSignIn()
        faceIDPressed()
        changeRegisterLabel()
        performRegularLoginRx()
        toRegisterVCRx()
        performForgotPassRx()
        setLogInAnonymouslyButton()
    }
    
    func setLogInAnonymouslyButton(){
        logInAnonymouslyButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.navigateToHome()
            })
            .disposed(by: disposeBag)
    }
    
    func performGSignIn(){
        let googleSignInButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleSignInPressed(_:)))
        customGSignInButton.addGestureRecognizer(googleSignInButtonTapGesture)
    }
    
    func faceIDPressed(){
        faceIdButton.setAnimateBounce()
        // Use RxSwift for faceIDButton tap event
        faceIdButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.faceID.authenticateUser() { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self?.navigationController?.pushViewController(self?.vc ?? UIViewController(), animated: true)
                        }
                    } else {
                        self?.showAlert(title: "Invalid Biometric", message: "This app does not get permission for biometric")
                    }
                }
            })
            .disposed(by: disposeBag)
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
    
    func performRegularLoginRx(){
        regularLoginButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.performRegularLogin()
            })
            .disposed(by: disposeBag)
    }
    
    func performRegularLogin(){
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
                self?.showAlert(title: "Success", message: "Login Successful, Welcome \(email)", completion: {
                    self?.navigateToHome()
                })
            }
        }
    }
    
    func toRegisterVCRx(){
        registerButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let registerVC = RegisterViewController()
                self?.navigationController?.pushViewController(registerVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        AlertUtility.showAlert(from: self, title: title, message: message, completion: completion)
    }
    
    func navigateToHome() {
        // Push to MainTabBarViewController
        let mainTabVC = MainTabBarViewController()
        self.navigationController?.pushViewController(mainTabVC, animated: true)
        // user: 1@a.com
        // pass: 123456
    }
    
    func performForgotPassRx(){
        forgotPassButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.showForgotPasswordPanel()
            })
            .disposed(by: disposeBag)
    }
    
    func showForgotPasswordPanel() {
        let contentVC = ForgotPassViewController()
        contentVC.modalPresentationStyle = .custom
        contentVC.transitioningDelegate = self
        present(contentVC, animated: true, completion: nil)
        
        // Add swipe down gesture for dismissal
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissHalfModal))
        swipeDown.direction = .down
        contentVC.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func dismissHalfModal() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - FloatingPanel Forgot Password
extension LoginViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - Perform GSignIn
extension LoginViewController {
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
    
    func showAlertForLoginError(_ error: Error?) {
        if let error = error {
            self.showAlert(title: "Login Error", message: error.localizedDescription)
            print("Login Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Hide Navigation
extension LoginViewController{
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
    
}

// TODO: - Crash when FaceID didnt match
