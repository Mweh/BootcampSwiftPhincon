//
//  ARViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 01/12/23.
//

import UIKit
import ARKit
import WebKit

class ARViewController: UIViewController, ARSCNViewDelegate, WKNavigationDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var webView: WKWebView!

    var urlString: String =  "https://www.youtube.com/embed/6TGg0_xtLoA"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)

        addWebView()
    }

    func addWebView() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        webView.navigationDelegate = self

        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)

        let webViewNode = SCNNode()
        webViewNode.geometry = SCNPlane(width: 0.3, height: 0.2)
        webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
        webViewNode.position = SCNVector3(0, 0, -0.5) // Adjust position as needed

        sceneView.scene.rootNode.addChildNode(webViewNode)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Handle webView didFinish loading event
    }

    // Add any additional ARSCNViewDelegate methods or other customization as needed
}
