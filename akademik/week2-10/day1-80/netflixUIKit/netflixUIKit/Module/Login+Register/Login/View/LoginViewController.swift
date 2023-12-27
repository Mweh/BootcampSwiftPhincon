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
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var regularLoginButton: UIButton!
    @IBOutlet weak var customGSignInButton: GIDSignInButton!
    @IBOutlet weak var faceIdButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var logInAnonymouslyButton: UIButton!
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private lazy var coordinator = LoginCoordinator(navigationController: self.navigationController!)
    private lazy var viewModel = LoginViewModel(coordinator: coordinator, navigationController: self.navigationController!)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind UI elements to ViewModel
        bindUI()
        // Customize the register button label
        changeRegisterLabel()
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
    
    // MARK: - UI Binding
    
    private func bindUI() {
        // Bind text fields to ViewModel properties
        bindTextFields()
        // Bind button taps to ViewModel actions
        bindButtons()
    }
    
    private func bindTextFields() {
        emailTextField.rx.text.bind(to: viewModel.emailText).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.passwordText).disposed(by: disposeBag)
    }
    
    private func bindButtons() {
        // Bind logInAnonymouslyButton tap to ViewModel action
        logInAnonymouslyButton.rx.tap
            .bind(to: viewModel.loginAnonymouslyTapped)
            .disposed(by: disposeBag)
        
        // Bind regularLoginButton tap to ViewModel action
        regularLoginButton.rx.tap
            .bind(to: viewModel.regularLoginTapped)
            .disposed(by: disposeBag)
        
        // Bind registerButton tap to ViewModel action
        registerButton.rx.tap
            .bind(to: viewModel.registerTapped)
            .disposed(by: disposeBag)
        
        // Bind forgotPassButton tap to ViewModel action
        forgotPassButton.rx.tap
            .bind(to: viewModel.forgotPasswordTapped)
            .disposed(by: disposeBag)
        
        // Bind faceIdButton tap to ViewModel action
        faceIdButton.rx.tap
            .bind(to: viewModel.faceIdTapped)
            .disposed(by: disposeBag)
        
        // Set up custom action for Google SignIn button
        customGSignInButton.addTarget(self, action: #selector(googleSignInPressed), for: .touchUpInside)
    }
    
    @objc private func googleSignInPressed() {
        // Perform Google Sign-In through ViewModel
        viewModel.performGoogleSignIn(withPresenting: self)
    }
    
    // Customize the label appearance for the registerButton
    private func changeRegisterLabel() {
        // Get the current title of the button
        guard let currentTitle = registerButton.title(for: .normal) else {
            return
        }
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: currentTitle)
        
        if let range = currentTitle.range(of: ConstantsLogin.stringChangeLabel) {
            // Apply the desired attributes to the specified range
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(range, in: currentTitle))
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: ConstantsLogin.sizeBoldFont), range: NSRange(range, in: currentTitle))
        }
        // Set the attributed string as the new title of the button
        registerButton.setAttributedTitle(attributedString, for: .normal)
    }
}
