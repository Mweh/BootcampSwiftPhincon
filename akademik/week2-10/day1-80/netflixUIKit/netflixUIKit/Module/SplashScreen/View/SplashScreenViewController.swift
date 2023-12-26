//
//  SplashScreen.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//

import Lottie
import UIKit
import RxSwift
import RxCocoa

class SplashScreenViewController: UIViewController {
    private var animationView: LottieAnimationView?
    private let viewModel: SplashScreenViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    // MARK: - Binding ViewModel

    func bindViewModel() {
        // Subscribe to navigateToLogin event from ViewModel
        viewModel.navigateToLogin
            .subscribe(onNext: { [weak self] in
                self?.navigateToLogin()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UI Configuration

    private func configureUI() {
        // Configure UI elements, e.g., Lottie animation
        configureLottie()
    }

    // MARK: - Lottie Animation Configuration

    private func configureLottie() {
        animationView = .init(name: ConstantsSplashScreen.animationName)
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = ConstantsSplashScreen.animationSpeed
        view.addSubview(animationView!)
        animationView!.play()
    }

    // MARK: - Navigation

    private func navigateToLogin() {
        // Navigate to the login view controller
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
