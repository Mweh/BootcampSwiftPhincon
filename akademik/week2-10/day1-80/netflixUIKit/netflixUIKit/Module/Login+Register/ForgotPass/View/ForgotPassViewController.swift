//
//  ForgotPassViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/11/23.
//

import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit

class ForgotPassViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetEmailButton: UIButton!
    
    lazy var loadingIndicator = PopUpLoading(on: view)
    let bag = DisposeBag()
    
    lazy var viewModel = ForgotPassViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.dismissImmediately()
        
        setupBinding()
    }
    
    func setupBinding() {
        resetEmailButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if let textEmailTextField = self?.emailTextField.text{
                    self?.viewModel.resetEmailTap(email: textEmailTextField)
                }
            }).disposed(by: bag)
        
        viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .loading:
                self.loadingIndicator.showInFull()
            case .fisnished:
                self.loadingIndicator.dismissImmediately()
            }
        })
        
        viewModel.isLoadingForgotPass.asObservable().subscribe(onNext: {[weak self] state in
            self?.loadingIndicator.dismissImmediately()
            switch state {
            case .isSuccess:
                if let email = self?.viewModel.email {
                    let successMessage = String(format: ConstantsForgotPass.Alert.passwordResetSuccessMessageTemplate, email)
                    self?.showAlert(title: ConstantsForgotPass.Alert.successTitle, message: successMessage, completion: {
                        // Completion handler code here
                    })
                }
            case .isFailed:
                if let errorMessage = self?.viewModel.errorMessage {
                    let errorMessage = String(format: ConstantsForgotPass.Alert.resetPasswordErrorMessageTemplate, errorMessage)
                    self?.showAlert(title: ConstantsForgotPass.Alert.errorTitle, message: errorMessage)
                }
            }
        })
        .disposed(by: bag)
    }
}
