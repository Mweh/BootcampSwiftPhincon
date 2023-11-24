//
//  TermAgreementViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 24/11/23.
//

import UIKit
import WebKit

class TermAgreementViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webBrowser: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeb()
    }
    
    func setWeb(){
        // Set the WKWebView navigation delegate
        webBrowser.navigationDelegate = self
        
        // Load the terms of use URL
        if let url = URL(string: "https://help.netflix.com/legal/termsofuse") {
            let request = URLRequest(url: url)
            webBrowser.load(request)
        }
    }
}
