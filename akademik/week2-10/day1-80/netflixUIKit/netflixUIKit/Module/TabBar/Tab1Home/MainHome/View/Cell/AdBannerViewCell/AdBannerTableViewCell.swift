//
//  AdBannerTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/12/23.
//

import GoogleMobileAds
import UIKit

class AdBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adBannerView: GADBannerView!
    private var rewardedAd: GADRewardedAd?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAd()
    }
    
    func setupAd(){
        adBannerView.adUnitID = ConstantAPIStuff.adBannerUnitID
        adBannerView.load(GADRequest())
        adBannerView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
        }
        )
    }
    
    
}

extension AdBannerTableViewCell: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func bannerView(_ bannadViewDidReceiveAderView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
