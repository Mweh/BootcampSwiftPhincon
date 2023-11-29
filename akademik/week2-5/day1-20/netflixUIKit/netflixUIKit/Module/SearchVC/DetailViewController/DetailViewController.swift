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
    @IBOutlet weak var lovedLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var slidingTabs: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tappableFadedImageView: TappableFadedImageView!
    
    var data: ResultNowPlaying?
    let vm = SearchViewModel()
    var dataDetails: Details?
    
    var counterValue: Int = 0
    var counterTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUp()
        setUpPagingVC()
        showNaviItem()
        
        setupHero()
        setupRightNavBarButtons()
        tappableFadedImageView.tapDelegate = self
        setupDetails()
    }
    
    func setupDetails(){
        if let data = data{
            self.vm.api.makeAPICall(endpoint: .getDetails(id: data.id)) { (response: Result<Details, Error>)  in
                switch response {
                case .success(let detailsId):
                    self.dataDetails = detailsId
                    self.setUpInfo()
                case .failure(let error):
                    print("Error fetching top rated movies: \(error)")
                }
            }
        }
    }
    
    @objc func shareButtonTapped() {
        // Your movie link from IMDb
        let movieLink = "https://www.imdb.com/title/example" //change this later
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [movieLink], applicationActivities: nil)
        //
        // Exclude some activities if needed (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact]
        
        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setupRightNavBarButtons() {
        let shareButton = UIBarButtonItem(systemItem: .action)
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        
        let browserURLButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(browserURLButtonTapped))
        browserURLButton.imageInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItems = [shareButton, browserURLButton]
    }
    
    @objc func browserURLButtonTapped() {
        // Your browser URL
        let browserURL = "https://www.example.com"
        
        // Open the URL in Safari
        if let url = URL(string: browserURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
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
        let totalLike = Int(data?.popularity ?? 0)+(data?.voteCount ?? 0)
        
        yearLabel.setSystemSymbolWithFormattedDate("calendar", date: data?.releaseDate, format: "yyyy")
        runtimeLabel.animateCounting(to: dataDetails?.runtime ?? 0, systemName: "clock")
        lovedLabel.animateCounting(to: totalLike, systemName: "heart")
        genreLabel.text = dataDetails?.genres?.prefix(3).compactMap { $0.name }.joined(separator: " • ")
    }
    
    func setupUp(){
        hidesBottomBarWhenPushed = true
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
            
            let posterPath = data.posterPath ?? ""
            
            let posterImgName = "https://image.tmdb.org/t/p/w300\(posterPath)"
            let posterURL = URL(string: posterImgName)
            posterImgView.kf.setImage(with: posterURL)
            posterImgView.sizeToFit()
            
            posterImgView.hero.id = "\(posterPath)"
            
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
        //        hidesBottomBarWhenPushed = false
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
            return ReviewsViewController(index: index, data: self.data)
        case .Similar:
            return SimilarViewController(dataResult: self.data)
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
