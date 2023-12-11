//
//  RegisterViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var toTermAgreementWeb: UIButton!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitial()
        setupRegister()
        toTermAgreementWebTap()
        setTextTermAgreement()
    }
    
    func setupInitial(){
        navigationItem.title = "Register"
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setTextTermAgreement() {
        let fullText = "By creating an account or signing you agree to our Terms and Conditions"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Find the range of "Terms and Conditions" in the full text
        if let range = fullText.range(of: "Terms and Conditions") {
            let nsRange = NSRange(range, in: fullText)
            
            // Apply bold and underline attributes to the specified range
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: nsRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        // Apply the attributed string to the button's title
        toTermAgreementWeb.setAttributedTitle(attributedString, for: .normal)
        
        // Center-align the text within the button
        toTermAgreementWeb.contentHorizontalAlignment = .center
        
        // Adjust title label properties for centering
        toTermAgreementWeb.titleLabel?.textAlignment = .center
        toTermAgreementWeb.titleLabel?.adjustsFontSizeToFitWidth = true
        toTermAgreementWeb.titleLabel?.minimumScaleFactor = 0.5
    }
    
    func toTermAgreementWebTap() {
        toTermAgreementWeb.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = GoToWebViewController()
                
                vc.urlString = URLs.netflixTermsOfUse
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
    func setupRegister(){
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleRegistration()
            })
            .disposed(by: bag)
    }
    
    func handleRegistration(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password  = passTextField.text, !password.isEmpty else{
            // Show alert for empty fields
            showAlert(title: "Error", message: "Please enter both email and password.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Print the error code for debugging
                print("Firebase Error Code: \((error as NSError).code)")
                
                // Handle registration error and show alert
                let errorCode = (error as NSError).code
                
                switch errorCode {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    // Handle case where the email is already registered
                    self?.showAlert(title: "Success", message: "Registration successful. Please use \(email) to log in."){
                        self?.navigationController?.popViewController(animated: true)
                    }
                default:
                    // Handle other registration errors
                    self?.showAlert(title: "Error", message: "Registration failed: \(error.localizedDescription)")
                }
            } else {
                // Registration successful, show success alert
                self?.showAlert(title: "Success", message: "Registration successful") {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
        handleRegistration()
    }
    
    // Your showAlert function
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        AlertUtility.showAlert(from: self, title: title, message: message, completion: completion)
    }
}

extension RegisterViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
