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

    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var resetEmailButton: UIButton!

    lazy var loadingIndicator = PopUpLoading(on: view)
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.dismissImmediately()
        setupRx()
    }

    func setupRx() {
        // Bind the email text field to a variable

        emailTextField.rx.text.orEmpty.bind(to: emailTextField.rx.text ).disposed(by: bag)
        // Bind the reset button tap event to a variable
        let resetButtonTapObservable = resetEmailButton.rx.tap.asObservable()

        // CombineLatest to ensure both email and reset button taps are valid
        resetButtonTapObservable.subscribe(onNext: { [weak self] _ in
            
            self?.resetPassword(email: self?.emailTextField?.text ?? "")
            })
            .disposed(by: bag)
    }

    func resetPassword(email: String) {
        // Disable the reset button and show activity indicator during the reset process
        resetEmailButton.isEnabled = false
        loadingIndicator.showInFull()

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            // Re-enable the reset button and hide activity indicator after the process
            self?.resetEmailButton.isEnabled = true
            self?.loadingIndicator.dismissImmediately()

            if let error = error {
                // Handle reset password error
                print("Reset Password Error: \(error.localizedDescription)")
                self?.showAlert(title: "Error", message: "Reset Password Error: \(error.localizedDescription)")
            } else {
                // Password reset email sent successfully
                print("Password reset email sent to \(email)")
                self?.showAlert(title: "Success", message: "Password reset email sent to \(email)", completion: {

                })
            }
        }
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        AlertUtility.showAlert(from: self, title: title, message: message, completion: completion)
    }
}
