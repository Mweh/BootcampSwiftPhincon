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
        UINavigationBar.appearance().isHidden = false
        setupUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        UINavigationBar.appearance().isHidden = false
    }

    func setupUp(){
        if let data = data {
            // Use the data to populate your detail view
            // For example, display details related to the selected movie.
            labelMovie.text = data.title
        }
    }
}
