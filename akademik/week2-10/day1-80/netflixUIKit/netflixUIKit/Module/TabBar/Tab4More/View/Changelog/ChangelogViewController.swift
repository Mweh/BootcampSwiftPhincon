//
//  ChangelogViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 11/12/23.
//

import UIKit

class ChangelogViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var changelogTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChangelogContent()
        setupTitle()
    }
    
    func setupTitle(){
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Changelog v\(version)\n\n"
        }
    }
    
    func loadChangelogContent() {
        if let path = Bundle.main.path(forResource: "CompletedTasks", ofType: "md") {
            do {
                let content = try String(contentsOfFile: path, encoding: .utf8)
                changelogTextView.text = content
                
            } catch {
                print("Error reading file: \(error)")
            }
        }
    }
}
