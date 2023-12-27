//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/12/23.
//

import FirebaseAuth
import GoogleSignIn
import LocalAuthentication
import RxCocoa
import RxSwift

class LoginViewModel {
    
    // MARK: - Dependencies
    
    private let faceID = FaceID()
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    let coordinator: LoginCoordinator
    let navigationController: UINavigationController
    
    // MARK: - Input
    
    let emailText = BehaviorRelay<String?>(value: nil)
    let passwordText = BehaviorRelay<String?>(value: nil)
    
    // MARK: - Output
    
    let loginAnonymouslyTapped = PublishRelay<Void>()
    let regularLoginTapped = PublishRelay<Void>()
    let registerTapped = PublishRelay<Void>()
    let forgotPasswordTapped = PublishRelay<Void>()
    let googleSignInTapped = PublishRelay<Void>()
    let faceIdTapped = PublishRelay<Void>()
    
    // MARK: - Initialization
    
    init(coordinator: LoginCoordinator, navigationController: UINavigationController) {
        self.coordinator = coordinator
        self.navigationController = navigationController
        
        // Setup bindings for various actions
        setupBindings()
    }
    
    // MARK: - Action Bindings
    
    private func setupBindings() {
        // Handle login anonymously action
        performLoginAnonymously()
        // Handle regular login action
        performRegularLogin()
        // Navigate to registration screen
        navigateToRegistration()
        // Show forgot password panel
        showForgotPasswordPanel()
        // Perform Face ID authentication
        performFaceId()
    }
    
    // MARK: - Action Handlers
    
    func performLoginAnonymously(){
        loginAnonymouslyTapped
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator.navigateToHome()
            })
            .disposed(by: disposeBag)
    }
    
    func performRegularLogin(){
        regularLoginTapped
            .subscribe(onNext: { [weak self] _ in
                // Get email and password from input fields
                guard let email = self?.emailText.value, let password = self?.passwordText.value else {
                    return // Return if email or password is nil
                }
                // Perform Firebase authentication
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error {
                        // Show error alert for login failure
                        self?.showAlert(title: ConstantsLogin.Titles.error, message: error.localizedDescription)
                    } else {
                        // Show success alert and navigate to home on successful login
                        self?.showAlert(title: ConstantsLogin.Titles.success, message: ConstantsLogin.Messages.success+email) {
                            self?.coordinator.navigateToHome()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToRegistration(){
        registerTapped
            .subscribe(onNext: { [weak self] _ in
                // Navigate to registration screen
                self?.coordinator.navigateToRegister()
            })
            .disposed(by: disposeBag)
    }
    
    func showForgotPasswordPanel(){
        forgotPasswordTapped
            .subscribe(onNext: { [weak self] _ in
                // Show forgot password panel
                self?.coordinator.presentForgotPassword()
            })
            .disposed(by: disposeBag)
    }
    
    func performFaceId() {
        faceIdTapped
            .subscribe(onNext: { [weak self] _ in
                // Perform Face ID authentication
                self?.faceID.authenticateUser() { isSuccess in
                    if isSuccess {
                        // Navigate to main tab view controller on successful Face ID
                        DispatchQueue.main.asyncAfter(deadline: ConstantsLogin.dispatchFaceIdTime) {
                            if let mainTabVC = self?.coordinator.mainTabVC {
                                self?.navigationController.pushViewController(mainTabVC, animated: true)
                            }
                        }
                    } else {
                        // Show error alert for Face ID failure
                        self?.showAlert(title: ConstantsLogin.Titles.errorFaceId, message: ConstantsLogin.Messages.errorFaceId)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func performGoogleSignIn(withPresenting viewController: UIViewController) {
        // Perform Google Sign-In
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            guard error == nil else { return }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            // Show success alert and navigate to main tab view controller on successful Google Sign-In
            self.showAlert(title: ConstantsLogin.Titles.success, message: ConstantsLogin.Messages.successGoogle) {
                self.navigationController.pushViewController(self.coordinator.mainTabVC, animated: true)
            }
        }
    }
}
