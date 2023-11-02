//
//  DetailViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var labelMovie: UILabel!
    var data: ResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        setupUp()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hidesBottomBarWhenPushed = false // Show the tab bar when inside DetailViewController
    }
    
    func setupUp(){
        if let data = data {
            // Use the data to populate your detail view
            // For example, display details related to the selected movie.
            labelMovie.text = data.title
        }
    }
}
