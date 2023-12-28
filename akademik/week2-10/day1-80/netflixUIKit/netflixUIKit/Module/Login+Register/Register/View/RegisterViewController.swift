//
//  RegisterViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import RxCocoa
import RxSwift
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var toTermAgreementWeb: UIButton!
    
    private let bag = DisposeBag()
    private lazy var coordinator = RegisterCoordinator(navigationController: self.navigationController!)
    private lazy var viewModel = RegisterViewModel(coordinator: coordinator, navigationController: self.navigationController!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
        bindUI()
        bindTextFields()
        setTextTermAgreement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupNavi(){
        navigationItem.title = ConstantsRegister.String.naviTitle
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bindTextFields() {
        emailTextField.rx.text.bind(to: viewModel.emailTextField).disposed(by: bag)
        passTextField.rx.text.bind(to: viewModel.passTextField).disposed(by: bag)
    }
    
    private func bindUI() {
        toTermAgreementWebTap()
        handleRegistration()
    }
    
    func toTermAgreementWebTap() {
        toTermAgreementWeb.rx.tap
            .bind(to: viewModel.toTermAgreementWebTapped)
            .disposed(by: bag)
    }
    
    func handleRegistration() {
        registerButton.rx.tap
            .bind(to: viewModel.registerTapped)
            .disposed(by: bag)
    }
    
    func setTextTermAgreement() {
        let fullText = ConstantsRegister.String.fullTextTerm
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Find the range of "Terms and Conditions" in the full text
        if let range = fullText.range(of: ConstantsRegister.String.trimTextTerm) {
            let nsRange = NSRange(range, in: fullText)
            
            // Apply bold and underline attributes to the specified range
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: ConstantsRegister.Int.fontSize), range: nsRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        // Apply the attributed string to the button's title
        toTermAgreementWeb.setAttributedTitle(attributedString, for: .normal)
        
        // Center-align the text within the button
        toTermAgreementWeb.contentHorizontalAlignment = .center
        
        // Adjust title label properties for centering
        if let titleTermAgreement = toTermAgreementWeb.titleLabel{
            titleTermAgreement.textAlignment = .center
            titleTermAgreement.adjustsFontSizeToFitWidth = true
            titleTermAgreement.minimumScaleFactor = ConstantsRegister.Int.minimumScaleFactor
        }
    }
}
