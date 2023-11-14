//
//  VideoTrailerVC.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import UIKit
import WebKit

class VideoTrailerVC: UIViewController {
    
    var videoKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        if let videoKey = videoKey {
            let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoKey)")!
            let webView = WKWebView(frame: view.bounds)
            webView.navigationDelegate = self
            view.addSubview(webView)
            
            let request = URLRequest(url: youtubeURL)
            webView.load(request)
        }
    }
}

extension VideoTrailerVC: WKNavigationDelegate{
    
}
