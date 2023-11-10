//
//  DetailViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var labelMovie: UILabel!
    @IBOutlet weak var overviewMovie: UILabel!
    
    var data: ResultTopRated?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        setupUp()
        showSkeleton()
    }
    
    func showSkeleton(){
        [imgView,
         labelMovie,
         overviewMovie
        ].forEach{
            $0?.showAnimatedGradientSkeleton()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hidesBottomBarWhenPushed = false
        // Show the tab bar when inside DetailViewController
        UINavigationBar.appearance().isHidden = false
    }
    
    func setupUp(){
        if let data = data {
            // Use the data to populate your detail view
            // For example, display details related to the selected movie.
            labelMovie.text = data.title
            overviewMovie.text = data.overview
            overviewMovie.sizeToFit()
            let imageName = "https://image.tmdb.org/t/p/w500\(data.posterPath)"
            let url = URL(string: imageName)
            imgView.kf.setImage(with: url)
            imgView.sizeToFit()
        }
    }
}
