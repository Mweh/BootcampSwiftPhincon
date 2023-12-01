//
//  GoToWebViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 24/11/23.
//

import UIKit
import WebKit

class GoToWebViewController: UIViewController {
    
    @IBOutlet weak var webBrowser: WKWebView!
    
    var urlString: String =  "https://www.google.com/error"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webBrowser.navigationDelegate = self
        setWeb()
    }
    
}

extension GoToWebViewController: WKNavigationDelegate{
    func setWeb() {
        // Set the WKWebView navigation delegate
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webBrowser.load(request)
    }
}
