//
//  DetailViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import Hero
import Parchment
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var backdropImgView: UIImageView!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var ratingContainer: UIView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var ratingLabel: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var viewsTotalLabel: UILabel!
    @IBOutlet weak var likedTotalLabel: UILabel!
    @IBOutlet weak var slidingTabs: UIView!
    
    @IBOutlet weak var tappableFadedImageView: TappableFadedImageView!
    
    var data: ResultNowPlaying?
    
    var counterValue: Int = 0
    var counterTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUp()
        setUpPagingVC()
        setUpInfo()
        showNaviItem()
        
        setupHero()
        setupShare()
        tappableFadedImageView.tapDelegate = self
    }
    
    func setupShare(){
        let shareButton = UIBarButtonItem(systemItem: .action)
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareButtonTapped() {
        // Your movie link from IMDb
        let movieLink = "https://www.imdb.com/title/example" //change this later
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [movieLink], applicationActivities: nil)
        
        // Exclude some activities if needed (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact]
        
        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)    }
    
    func setupHero(){
        self.hero.isEnabled = true
    }
    
    func setUpPagingVC(){
        let firstVC = SynopsisViewController(index: 0, data: self.data)
        let pagingVC = PagingViewController(viewControllers: [firstVC])
        pagingVC.dataSource = self
        pagingVC.delegate = self
        pagingVC.menuItemSize = .selfSizing(estimatedWidth: 50, height: 40)
        
        addChild(pagingVC)
        slidingTabs.addSubview(pagingVC.view)
        
        // Set constraints to make the pagingVC.view fill the slidingTabs view
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingVC.view.topAnchor.constraint(equalTo: slidingTabs.topAnchor),
            pagingVC.view.leadingAnchor.constraint(equalTo: slidingTabs.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: slidingTabs.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: slidingTabs.bottomAnchor)
        ])
        
        pagingVC.didMove(toParent: self)
        
        pagingVC.selectedTextColor = UIColor.systemRed
        pagingVC.indicatorColor = UIColor.systemRed
        pagingVC.textColor = UIColor.label
        pagingVC.menuBackgroundColor = UIColor.clear
        
        firstVC.descLabel?.text = data?.overview
        
    }
    
    func setUpInfo(){
        yearLabel.setSystemSymbolWithFormattedDate("calendar", date: data?.releaseDate, format: "yyyy")
        viewsTotalLabel.animateCounting(to: Int(data?.popularity ?? 0), systemName: "flame")
        likedTotalLabel.animateCounting(to: data?.voteCount ?? 0, systemName: "heart")
    }
    
    func setupUp(){
        self.navigationItem.title = data?.originalTitle ?? "Detail"
        backdropImgView.makeRounded(30)
        posterImgView.makeImageRounded(10)
        ratingContainer.makeRounded(10)
        
        if let data = data {
            titleMovieLabel.text = data.title ?? ""
            
            titleMovieLabel.hero.id = "\(data.title!)"
            
            let backdropImgName = "https://image.tmdb.org/t/p/w500\(data.backdropPath ?? "")"
            let backdropURL = URL(string: backdropImgName)
            backdropImgView.kf.setImage(with: backdropURL)
            backdropImgView.sizeToFit()
            
            backdropImgView.hero.id = "\(data.backdropPath ?? "")"
            
            let posterImgName = "https://image.tmdb.org/t/p/w300\(data.posterPath)"
            let posterURL = URL(string: posterImgName)
            posterImgView.kf.setImage(with: posterURL)
            posterImgView.sizeToFit()
            
            posterImgView.hero.id = "\(data.posterPath)"
            print(data.posterPath)
            
            let voteAverageText = String(format: "%.1f", data.voteAverage)
            let attributedText = NSAttributedString(string: voteAverageText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
            
            ratingLabel.setAttributedTitle(attributedText, for: .normal)
        }
    }
}

extension DetailViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        showNaviItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        showNaviItem()
    }
    
    func showNaviItem(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hidesBottomBarWhenPushed = false
        // Show the tab bar when inside DetailViewController
        UINavigationBar.appearance().isHidden = false
    }
}

extension DetailViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return DetailSlidingTabs.allCases.count // Update the number of view controllers
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        
        guard let tab = DetailSlidingTabs(rawValue: index) else {
            fatalError("Invalid index for view controller")
        }
        switch tab {
        case .Synopsis:
            return SynopsisViewController(index: index, data: self.data)
        case .Cast:
            return CastingViewController(index: index, data: self.data)
        case .Reviews:
            return ReviewsViewController()
        case .Similar:
            return SimilarViewController()
        }
        
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        guard let tab = DetailSlidingTabs(rawValue: index) else {
            fatalError("Invalid index for paging item")
        }
        
        switch tab {
        case .Synopsis:
            return PagingIndexItem(index: index, title: "About Movie")
        case .Cast:
            return PagingIndexItem(index: index, title: "Cast")
        case .Reviews:
            return PagingIndexItem(index: index, title: "Reviews")
        case .Similar:
            return PagingIndexItem(index: index, title: "Similar")
        }
    }
    
}

extension DetailViewController: Tappable {
    func didTap() {
        let videoTrailerVC = VideoTrailerVC(nibName: "VideoTrailerVC", bundle: nil)
        videoTrailerVC.hidesBottomBarWhenPushed = true
        // Pass the movie ID to the VideoTrailerVC
        videoTrailerVC.movieId = data?.id
        navigationController?.pushViewController(videoTrailerVC, animated: true)
    }
}

enum DetailSlidingTabs: Int, CaseIterable{
    case Synopsis
    case Cast
    case Reviews
    case Similar
}
