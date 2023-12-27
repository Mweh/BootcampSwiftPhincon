//
//  DisplayLanguageViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 12/12/23.
//

import LanguageManager_iOS
import RxSwift
import UIKit

class DisplayLanguageViewController: UIViewController {
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var bahasaButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLanguages()
    }
    
    func setupLanguages(){
        let enLanguage: Languages = .en
        let idLanguage: Languages = .id
        
        englishButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.setLanguage(language: enLanguage)
            })
            .disposed(by: disposeBag)
        
        bahasaButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.setLanguage(language: idLanguage)
            })
            .disposed(by: disposeBag)
    }
    
    func setLanguage(language: Languages){
        // change the language
        LanguageManager.shared.setLanguage(language: language)
        { title -> UIViewController in
            let vc = MainTabBarController()
            // the view controller that you want to show after changing the language
            return vc
        } animation: { view in
            // do custom animation
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
        }
    }
}
