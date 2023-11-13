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
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
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
