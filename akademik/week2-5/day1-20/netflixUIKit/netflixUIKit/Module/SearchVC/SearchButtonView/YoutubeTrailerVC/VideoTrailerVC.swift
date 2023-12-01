//
//  VideoTrailerVC.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import UIKit
import WebKit

class VideoTrailerVC: UIViewController {
    
    var movieId: Int?
    @IBOutlet weak var webYoutubeView: WKWebView!
    let vm = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if movieId is available before loading the YouTube video
        if let movieId = movieId {
            loadYouTubeVideo(for: movieId)
        }
        showNaviItem()
        let arButton = UIBarButtonItem(systemItem: .camera)
        arButton.target = self
        arButton.action = #selector(arButtonTapped)
        navigationItem.rightBarButtonItem = arButton

    }
    
    @objc func arButtonTapped() {
        let vc = ARViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func loadYouTubeVideo(for movieId: Int) {
        let videoTrailerEndpoint = Endpoint.getVideoTrailer(id: movieId)
        
        // Make a network request to get the video information
        vm.api.makeAPICall(endpoint: videoTrailerEndpoint) { [weak self] (result: Result<VideoTrailer, Error>) in
            switch result {
            case .success(let videoTrailer):
                // Assuming the first result is the video you want
                if let firstVideo = videoTrailer.results.first {
                    // Extract the key from the video information
                    let videoKey = firstVideo.key
                    
                    // Use the video key to construct the YouTube URL and load it into WKWebView
                    let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoKey)")
                    let request = URLRequest(url: youtubeURL!)
                    self?.webYoutubeView.load(request)
                }
            case .failure(let error):
                print("Error fetching video trailer: \(error)")
            }
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
