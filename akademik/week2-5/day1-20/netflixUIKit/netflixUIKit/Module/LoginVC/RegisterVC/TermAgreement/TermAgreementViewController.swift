//
//  TermAgreementViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 24/11/23.
//

import UIKit
import WebKit

class TermAgreementViewController: UIViewController {
    
    @IBOutlet weak var webBrowser: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example usage with a default URL
        setWeb(url: URL(string: "https://help.netflix.com/legal/termsofuse")!)
    }
}

extension TermAgreementViewController: WKNavigationDelegate{
    func setWeb(url: URL) {
        // Set the WKWebView navigation delegate
        webBrowser.navigationDelegate = self
        
        // Load the specified URL
        let request = URLRequest(url: url)
        webBrowser.load(request)
    }
}
