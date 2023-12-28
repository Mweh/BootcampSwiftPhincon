//
//  ForgotPassViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 28/12/23.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift

enum StateLoadingForgotPass{
    case isSuccess, isFailed
}

class ForgotPassViewModel{
    
    private let bag = DisposeBag()
    
    var errorMessage: String?
    var email: String?
    
    var isLoading = BehaviorRelay<StateLoading>(value: .fisnished)
    var isLoadingForgotPass = BehaviorRelay<StateLoadingForgotPass>(value: .isSuccess)
    let resetButtonEnabled = BehaviorRelay<Bool>(value: true)
        
    func resetEmailTap(email: String){
        isLoading.accept(.loading)
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            // Re-enable the reset button and hide activity indicator after the process
            self?.resetButtonEnabled.accept(true)
            
            if let error = error {
                // Handle reset password error
                self?.errorMessage = error.localizedDescription
                self?.isLoadingForgotPass.accept(.isFailed)
            } else {
                // Password reset email sent successfully
                self?.email = email
                self?.isLoadingForgotPass.accept(.isSuccess)
            }
        }
    }
}
