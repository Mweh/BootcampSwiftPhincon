//
//  DetailViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import CoreData
import Hero
import Parchment
import UIKit

enum isFor{
    case isForMainContent
    case isForHistory
}

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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    
    var data: ResultMovie?
    let vm = SearchViewModel()
    var dataDetails: Details?
    
    var totalCast: Int?
    var pagingVC: PagingViewController?
    
    var isFor: isFor = .isForMainContent
    
    var movieId: Int?
    
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
        addFloatingIcon(useLottie: true, lottieFileName: "floatingIconPlays", iconSize: 80)
    }
    
    override func floatingIconTapped() {
        // Implement the code to push to another view controller
        let vc = AllVideoViewController()
        vc.dataResultMovie = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupDetails(){
        let id = isFor == .isForHistory ? (movieId ?? 0 ): (data?.id ?? 0)
        self.vm.api.makeAPICall(endpoint: .getDetails(id: id)) { (response: Result<Details, Error>)  in
            switch response {
            case .success(let detailsId):
                self.dataDetails = detailsId
                self.setUpInfo()
            case .failure(let error):
                print("Error fetching top rated movies: \(error)")
            }
        }
    }
    
    @objc func shareButtonTapped() {
        // Your movie link from IMDb
        if let data = dataDetails?.homepage{
            let movieLink = data
            // Create an instance of UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: [movieLink], applicationActivities: nil)
            //
            // Exclude some activities if needed (optional)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact]
            
            // Present the share sheet
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func setupRightNavBarButtons() {
        let shareButton = UIBarButtonItem(systemItem: .action)
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        
        let browserURLButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(browserURLButtonTapped))
        browserURLButton.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItems = [shareButton, browserURLButton]
    }
    
    @objc func browserURLButtonTapped() {
        // Your browser URL
        if let dataToIMDB = dataDetails?.imdbID{
            let browserURL = "https://www.imdb.com/title/\(dataToIMDB)"
            
            // Open the URL in Safari
            if let url = URL(string: browserURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func setupHero(){
        self.hero.isEnabled = true
    }
    
    func setUpPagingVC(){
        let firstVC = SynopsisViewController(index: 0, data: self.data)
        
        pagingVC = PagingViewController(viewControllers: [firstVC])
        
        if let pagingVC = pagingVC {
            
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
            pagingVC.textColor = UIColor.secondaryLabel
            pagingVC.menuBackgroundColor = UIColor.clear
        }
        firstVC.descLabel?.text = data?.overview
    }
    
    func setUpInfo(){
        let totalLike = Int(data?.popularity ?? 0)+(data?.voteCount ?? 0)
        
        yearLabel.setSystemSymbolWithFormattedDate("calendar", date: data?.releaseDate, format: "yyyy")
        runtimeLabel.animateCountingHour(to: dataDetails?.runtime ?? 0, systemName: "clock")
        lovedLabel.animateCounting(to: totalLike, systemName: "heart")
        genreLabel.text = dataDetails?.genres?.prefix(3).compactMap { $0.name }.joined(separator: " • ")
        statusLabel.text = dataDetails?.status
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        
        if let budget = dataDetails?.budget, budget > 0 {
            budgetLabel.text = "Budget: " + numberFormatter.string(from: NSNumber(value: budget))!
            budgetLabel.animateCounting(to: budget)
        } else {
            budgetLabel.text = "Budget: N/A"
        }
        
        if let revenue = dataDetails?.revenue, revenue > 0 {
            revenueLabel.text = "Revenue: " + numberFormatter.string(from: NSNumber(value: revenue))!
        } else {
            revenueLabel.text = "Revenue: N/A"
        }
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
            
            let tmdbImgBase500 = TMDBImageURL.url(size: .w500)
            let backdropImgName = "\(tmdbImgBase500)\(data.backdropPath ?? "")"
            let backdropURL = URL(string: backdropImgName)
            backdropImgView.kf.setImage(with: backdropURL)
            backdropImgView.sizeToFit()
            
            backdropImgView.hero.id = "\(data.backdropPath ?? "")"
            
            let tmdbImgBase342 = TMDBImageURL.url(size: .w342)
            let posterPath = data.posterPath ?? ""
            let posterImgName = "\(tmdbImgBase342)\(posterPath)"
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
            return CastingViewController(index: index, data: self.data, delegate: self)
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
            let vc = CastingViewController(index: index, data: self.data, delegate: self)
            return PagingIndexItem(index: index, title: "Cast \(self.totalCast ?? 0)")
        case .Reviews:
            let vc = ReviewsViewController(index: index, data: self.data)
            let total = vc.dataReviews?.totalResults ?? 0
            return PagingIndexItem(index: index, title: "Reviews \(total)")
        case .Similar:
            let vc = SimilarViewController(dataResult: self.data)
            let total = vc.data?.totalResults ?? 0
            return PagingIndexItem(index: index, title: "Similar \(total)")
        }
    }
}

extension DetailViewController: Tappable {
    func didTap() {
        let videoTrailerVC = VideoTrailerVC(nibName: "VideoTrailerVC", bundle: nil)
        videoTrailerVC.hidesBottomBarWhenPushed = true
        videoTrailerVC.movieId = data?.id
        
        saveToHistory()
        navigationController?.pushViewController(videoTrailerVC, animated: true)
        
    }
    
    func saveToHistory() {
        guard let data = data else {
            return
        }

        // Unwrap optional properties before creating HistoryModelMovie
        if let posterPath = data.posterPath,
           let title = data.title,
           let releaseDate = data.releaseDate,
           let genres = dataDetails?.genres?.first?.name,
           let runtime = dataDetails?.runtime{

            let historyMovie = HistoryModelMovie(
                id: data.id,
                posterPath: posterPath,
                title: title,
                voteAverage: data.voteAverage,
                genres: genres,
                releaseDate: releaseDate,
                runtime: runtime
            )

            // Save movie to history using CoreDataHelper
            CoreDataHelper.shared.saveMovieToHistory(data: historyMovie)
            
        }
    }

    
}

enum DetailSlidingTabs: Int, CaseIterable{
    case Synopsis
    case Cast
    case Reviews
    case Similar
}

extension DetailViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        showNaviItem()
        setupDetails()
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
        // Show the tab bar when inside DetailViewController
        UINavigationBar.appearance().isHidden = false
    }
}

extension DetailViewController: CastingViewControllerDelegate{
    func updateMenu(total: Int) {
        self.totalCast = total
        self.pagingVC?.reloadMenu()
    }
}
