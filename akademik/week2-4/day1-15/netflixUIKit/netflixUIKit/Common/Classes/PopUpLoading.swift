//
//  PopUpLoading.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 17/11/23.
//

import UIKit
import Lottie
import FirebaseCoreInternal

/// Can be used as loading indicator while fetching data on BE.
/// Sample use is at the end of this class
/// - Initialize this class with `UIView` on which it will appear on
/// - call function `show()` to show the loading animation.
/// - call function `dismiss()` to dismiss the loading animation and remove it from `superView`.
class PopUpLoading {
    
    private let widthHeight: CGFloat = 350
    private var parentView: UIView
    private var animationView = LottieAnimationView(name: "loadingIndicator")
    private var backgroundCover: UIView
    private let common = Common.shared
    var customBackgroundColor: UIColor = UIColor()
    
    init(on view: UIView) {
        self.parentView = view
        animationView.alpha = 0.3
        animationView.isHidden = true
        self.backgroundCover = UIView()
        self.backgroundCover.backgroundColor = .clear
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)

    }
    
    private func animateView() {
        animationView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.6) { [weak self] () in
                guard let self = self else { return }
                self.animationView.isHidden = false
                self.animationView.alpha = 1
                self.animationView.transform = .identity
            } .startAnimation()
    }
    
    func show() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAnimation), name: UIScene.willEnterForegroundNotification, object: nil)
        backgroundCover.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCover.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(backgroundCover)
        backgroundCover.addSubview(animationView)
        if let header = parentView.viewWithTag(99) {
            parentView.bringSubviewToFront(header)
        }
        NSLayoutConstraint.activate([
            backgroundCover.topAnchor.constraint(equalTo: parentView.topAnchor),
            backgroundCover.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            backgroundCover.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            backgroundCover.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            animationView.widthAnchor.constraint(equalToConstant: widthHeight),
            animationView.heightAnchor.constraint(equalToConstant: widthHeight),
            animationView.centerXAnchor.constraint(equalTo: backgroundCover.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: backgroundCover.centerYAnchor)
        ])
        animateView()
    }
    
    func showWithCustomBackgroundColor() {
        backgroundCover.backgroundColor = customBackgroundColor
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCover.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(backgroundCover)
        if let header = parentView.viewWithTag(99) {
            parentView.bringSubviewToFront(header)
        }
        backgroundCover.addSubview(animationView)
        NSLayoutConstraint.activate([
            backgroundCover.topAnchor.constraint(equalTo: parentView.topAnchor),
            backgroundCover.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            backgroundCover.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            backgroundCover.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            animationView.widthAnchor.constraint(equalToConstant: widthHeight),
            animationView.heightAnchor.constraint(equalToConstant: widthHeight),
            animationView.centerXAnchor.constraint(equalTo: backgroundCover.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: backgroundCover.centerYAnchor)
        ])
        animateView()
    }
    
    func showInFull() {
        backgroundCover.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        common.addViewToWindow { window in
            window.addSubview(backgroundCover)
            backgroundCover.tag = 100
            backgroundCover.addSubview(animationView)
            NSLayoutConstraint.activate([
                animationView.widthAnchor.constraint(equalToConstant: widthHeight),
                animationView.heightAnchor.constraint(equalToConstant: widthHeight),
                animationView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            ])
            animateView()
        }
    }
    
    func dismissAfter1() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
            self.animationView.stop()
        }
    }
    
    func dismissImmediately() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        DispatchQueue.main.async { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
            self.animationView.stop()
        }
    }
    
    @objc func reloadAnimation() {
        animationView.play()
    }
}

