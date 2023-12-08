import GoogleMobileAds
import Lottie
import UIKit

extension UIViewController {
    
    func loadRewardedAd(completion: @escaping (GADRewardedAd?) -> Void) {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: BaseConstant.adRewardedUnitID, request: request) { ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("Rewarded ad loaded.")
                completion(ad)
            }
        }
    }

    func showRewardedAd(ad: GADRewardedAd, completion: @escaping () -> Void) {
        ad.present(fromRootViewController: self) {
            let reward = ad.adReward
            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
            // TODO: Reward the user.
            completion()
        }
    }
}

extension UIViewController {
    func showPopupMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func addFloatingIcon(useLottie: Bool = false, lottieFileName: String? = nil, iconSize: CGFloat = 45, trailingValue: CGFloat = -16, bottomValue: CGFloat = -16, showCloseButton: Bool = true) {
        var floatingIcon: UIView!
        
        // Create the floating icon as a UIView or Lottie animation view based on the parameter
        if useLottie, let lottieFileName = lottieFileName {
            let animationView = LottieAnimationView()
            animationView.animation = LottieAnimation.named(lottieFileName)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            floatingIcon = animationView
        } else {
            floatingIcon = UIView()
            floatingIcon.backgroundColor = .systemRed
            floatingIcon.layer.cornerRadius = iconSize / 2
            floatingIcon.layer.masksToBounds = true
        }
        
        // Add tap gesture for handling icon tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(floatingIconTapped))
        floatingIcon.addGestureRecognizer(tapGesture)
        
        if showCloseButton {
            // Create a close button
            let closeButton = UIButton(type: .custom)
            closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            closeButton.tintColor = .white
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            
            // Add the close button as a subview to the floating icon
            floatingIcon.addSubview(closeButton)
            
            // Add constraints for the close button inside the floating icon
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.trailingAnchor.constraint(equalTo: floatingIcon.trailingAnchor, constant: 0),
                closeButton.topAnchor.constraint(equalTo: floatingIcon.topAnchor, constant: 0),
                closeButton.widthAnchor.constraint(equalToConstant: iconSize / 2),
                closeButton.heightAnchor.constraint(equalToConstant: iconSize / 2)
            ])
        }
        
        // Add the floating icon to the view
        view.addSubview(floatingIcon)
        
        // Set the size programmatically
        floatingIcon.frame.size = CGSize(width: iconSize, height: iconSize)
        
        // Add constraints for the floating icon to be initially positioned at the bottom right corner
        floatingIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingValue),
            floatingIcon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomValue),
            floatingIcon.widthAnchor.constraint(equalToConstant: iconSize),
            floatingIcon.heightAnchor.constraint(equalToConstant: iconSize)
        ])
        
        // Make the floating icon draggable
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        floatingIcon.addGestureRecognizer(panGesture)
    }

    @objc func closeButtonTapped(_ sender: UIButton) {
        // Handle close button tap
        // Implement code to hide or remove the floating icon
        guard let floatingIcon = sender.superview else {
            return
        }
        floatingIcon.removeFromSuperview()
    }

    @objc func floatingIconTapped() {
        // Handle icon tap
        // Implement code to hide or show the detail view or perform other actions
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        guard let floatingIcon = gesture.view else { return }

        // Update the floating icon's position based on the gesture
        floatingIcon.center = CGPoint(x: floatingIcon.center.x + translation.x, y: floatingIcon.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)

        if gesture.state == .ended {
            // Implement logic for snapping to the edge
            let screenWidth = view.bounds.width
            let screenHeight = view.bounds.height

            let finalX: CGFloat
            let finalY: CGFloat

            // Calculate the final position based on the current position
            if floatingIcon.center.x < screenWidth / 2 {
                finalX = 16 + floatingIcon.bounds.width / 2
            } else {
                finalX = screenWidth - 16 - floatingIcon.bounds.width / 2
            }

            // You can customize the vertical position if needed
            finalY = min(max(floatingIcon.center.y, floatingIcon.bounds.height / 2), screenHeight - floatingIcon.bounds.height / 2)

            // Animate the snap effect
            UIView.animate(withDuration: 0.3) {
                floatingIcon.center = CGPoint(x: finalX, y: finalY)
            }
        }
    }
}

