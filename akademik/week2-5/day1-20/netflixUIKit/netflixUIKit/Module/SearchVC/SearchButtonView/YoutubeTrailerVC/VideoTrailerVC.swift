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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if movieId is available before loading the YouTube video
        if let movieId = movieId {
            loadYouTubeVideo(for: movieId)
        }
    }
    
    func loadYouTubeVideo(for movieId: Int) {
        let videoTrailerEndpoint = Endpoint.getVideoTrailer(id: movieId)
        
        // Make a network request to get the video information
        CustomAPIManager.shared.makeAPICall(endpoint: videoTrailerEndpoint) { [weak self] (result: Result<VideoTrailer, Error>) in
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
