//
//  RewardedAdViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/12/23.
//

import GoogleMobileAds
import UIKit

class RewardedAdViewController: UIViewController {
    
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load rewarded ad
        loadRewardedAd { [weak self] ad in
            self?.rewardedAd = ad
            // You can now use the rewardedAd as needed
        }
    }
    
    func showRewardedAd() {
        if let ad = rewardedAd {
            // Show the rewarded ad
            showRewardedAd(ad: ad) { [weak self] in
                // Completion handler is called after the user interacts with the ad
                // TODO: Proceed with additional logic
            }
        } else {
            // Handle the case where the rewarded ad is not ready
        }
    }
}

extension RewardedAdViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
