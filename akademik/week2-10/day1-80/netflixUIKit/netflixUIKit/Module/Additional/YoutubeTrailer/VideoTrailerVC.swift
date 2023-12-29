//
//  VideoTrailerVC.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import GoogleMobileAds
import UIKit
import WebKit

class VideoTrailerVC: UIViewController {
    
    var movieId: Int?
    @IBOutlet weak var webYoutubeView: WKWebView!
    @IBOutlet weak var viewContainer: UIView!
    let vm = SearchViewModel()
    
    private var rewardedAd: GADRewardedAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainer.isHidden = true
        loadRewardedAd()
        setupBrowser()
        setupAR()
    }
    
    func setupAR(){
        let arButton = UIBarButtonItem(systemItem: .camera)
        arButton.target = self
        arButton.action = #selector(arButtonTapped)
        navigationItem.rightBarButtonItem = arButton

    }
    
    @objc func arButtonTapped() {
        let vc = ARViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func setupBrowser(){
        // Check if movieId is available before loading the YouTube video
        if let movieId = movieId {
            loadYouTubeVideo(for: movieId)
        }
        showNaviItem()
    }
    
    func loadYouTubeVideo(for movieId: Int) {
        let videoTrailerEndpoint = Endpoint.getVideoTrailer(id: movieId)
        
        // Make a network request to get the video information
        vm.api.makeAPICall(endpoint: videoTrailerEndpoint) { [weak self] (result: Result<VideoTrailer, Error>) in
            switch result {
            case .success(let videoTrailer):
                // Assuming the first result is the video you want
                if let firstVideo = videoTrailer.results?.first {
                    // Extract the key from the video information
                    guard let videoKey = firstVideo.key else { return  }
                    
                    // Use the video key to construct the YouTube URL and load it into WKWebView
                    if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoKey)"){
                        let request = URLRequest(url: youtubeURL)
                        self?.webYoutubeView.load(request)
                    }
                }
            case .failure(let error):
                print("Error fetching video trailer: \(error)")
            }
        }
    }
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: ConstantAPIStuff.adRewardedUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }

            self.rewardedAd = ad
            print("Rewarded ad loaded.")
//            self.rewardedAd?.fullScreenContentDelegate = self
            viewContainer.isHidden = false
            self.showRewardedAd()
        }
    }

    func showRewardedAd() {
        guard let ad = rewardedAd else {
            print("Ad wasn't ready")
            return
        }

        ad.present(fromRootViewController: self) {
            let reward = ad.adReward
            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
            // TODO: Reward the user.
        }
    }
}

extension VideoTrailerVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        showNaviItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        showNaviItem()
    }
    func showNaviItem(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
