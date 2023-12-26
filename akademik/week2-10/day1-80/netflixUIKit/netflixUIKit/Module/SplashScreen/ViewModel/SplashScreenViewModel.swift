//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 26/12/23.
//

import Foundation
import RxSwift
import RxCocoa

struct ConstantsSplashScreen {
    static let animationName = "netflixLottie"
    static let animationSpeed = 0.5
    static let navigationDelayInSeconds = 6
}

class SplashScreenViewModel {
    private let navigateSubject = PublishSubject<Void>()
    let navigateToLogin: Observable<Void>

    private let disposeBag = DisposeBag()

    init(trigger: Observable<Void>) {
        // Expose navigateToLogin as an Observable to the outside
        navigateToLogin = navigateSubject.asObservable()

        // Bind triggers to initiate navigation
        bindTriggers(trigger)
    }

    // MARK: - Trigger Binding

    private func bindTriggers(_ trigger: Observable<Void>) {
        trigger
            .delay(.seconds(ConstantsSplashScreen.navigationDelayInSeconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak navigateSubject] in
                navigateSubject?.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
