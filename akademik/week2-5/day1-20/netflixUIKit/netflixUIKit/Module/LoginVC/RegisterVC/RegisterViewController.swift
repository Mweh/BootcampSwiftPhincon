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

        setupBindings()
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        toTermAgreementWebTap()
        setTextTermAgreement()
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

    func setupBindings(){
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handRegistration()
            })
            .disposed(by: bag)
    }
    
    func handRegistration(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password  = passTextField.text, !password.isEmpty else{
            // do smthng, handle email/pass is missing
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            if let error = error{
                // hand registraion error
                print("Registration Error: \(error.localizedDescription)")
            } else{
                let vc = MainTabBarViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
        let vc = MainTabBarViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
