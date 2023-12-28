//
//  RegisterViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/12/23.
//

import FirebaseAuth
import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel{
    
    private let bag = DisposeBag()
    let coordinator: RegisterCoordinator
    let navigationController: UINavigationController
    
    let emailTextField = BehaviorRelay<String?>(value: nil)
    let passTextField = BehaviorRelay<String?>(value: nil)
    
    let toTermAgreementWebTapped = PublishRelay<Void>()
    let registerTapped = PublishRelay<Void>()
    
    init(coordinator: RegisterCoordinator, navigationController: UINavigationController) {
        self.coordinator = coordinator
        self.navigationController = navigationController
        
        setupBindings()
    }
    
    func setupBindings(){
        toTermAgreementWebTap()
        registerTap()
    }
    
    func toTermAgreementWebTap() {
        toTermAgreementWebTapped
            .subscribe(onNext: { [weak self] in
                self?.coordinator.navigateToWebViewController()
            })
            .disposed(by: bag)
    }
    
    func registerTap(){
        registerTapped
            .subscribe(onNext: {[weak self] in
                guard let email = self?.emailTextField.value, !email.isEmpty,
                      let password  = self?.passTextField.value, !password.isEmpty else{
                    // Show alert for empty fields
                    self?.showAlert(title: ConstantsRegister.String.errorTitle, message: ConstantsRegister.String.errorMessage)
                    return
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error {
                        
                        // Handle registration error and show alert
                        let errorCode = (error as NSError).code
                        
                        switch errorCode {
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            // Handle case where the email is already registered
                            self?.showAlert(title: ConstantsRegister.String.errorTitle, message: String(format: ConstantsRegister.String.registrationSuccessTemplate, email)){
                                self?.coordinator.popNaviToLogin()
                            }
                        default:
                            // Handle other registration errors
                            self?.showAlert(title: ConstantsRegister.String.errorTitle, message: String(format: ConstantsRegister.String.registerFailedMessage, error.localizedDescription))
                        }
                    } else {
                        // Registration successful, show success alert
                        self?.showAlert(title: ConstantsRegister.String.successTitle, message: ConstantsRegister.String.successMessage) {
                            self?.coordinator.popNaviToLogin()
                        }
                    }
                }
            })
            .disposed(by: bag)
    }
    
    // Your showAlert function
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        AlertUtility.showAlert(from: navigationController, title: title, message: message, completion: completion)
    }
}
