//
//  AppSettingsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/11/23.
//

import RxSwift
import UIKit

class AppSettingsViewController: UIViewController {
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpeed()
        setupPrivacy()
        setupToggleDarkMode()
    }
    
    func setupToggleDarkMode(){
        // Observe switch value changes using RxSwift
        switchDarkMode.rx.value
            .subscribe(onNext: { [weak self] isDarkMode in
                // Toggle between light and dark mode based on the switch state
                let userInterfaceStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = userInterfaceStyle
                }
            })
            .disposed(by: bag)
        
        // Set the initial state for the switch based on the current user interface style
        setDarkMode()
    }
    
    // Set the initial state for the switch based on the current user interface style
    func setDarkMode() {
        let currentStyle = UIApplication.shared.windows.first?.overrideUserInterfaceStyle ?? .unspecified
        switchDarkMode.isOn = currentStyle == .dark
    }
    
    func setupSpeed(){
        speedButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let vc = GoToWebViewController()

                vc.urlString = URLs.fastDotCom
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: bag)
    }
    
    func setupPrivacy(){
        privacyButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let vc = GoToWebViewController()
                
                vc.urlString = URLs.netflixPrivacy
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: bag)
    }
}
