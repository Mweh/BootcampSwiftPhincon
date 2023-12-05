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
//        setupDetails()
        
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
        videoTrailerVC.movieId = data?.id
        
        saveToHistory()
        navigationController?.pushViewController(videoTrailerVC, animated: true)
    }
    func saveToHistory() {
        guard let data = data else {
            return
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", data.id)

        do {
            let results = try context.fetch(fetchRequest)

            if let existingMovie = results.first as? NSManagedObject {
                // Movie with the same ID already exists, you can update or skip
                // For simplicity, let's just skip adding the duplicate
                print("Movie with ID \(data.id) already exists in history.")
            } else {
                // Movie with this ID doesn't exist, proceed to add it
                if let movieEntity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context) {
                    let movieItem = NSManagedObject(entity: movieEntity, insertInto: context)

                    movieItem.setValue(data.id, forKey: "id")
                    movieItem.setValue(data.posterPath, forKey: "posterPath")
                    movieItem.setValue(data.title, forKey: "title")
                    movieItem.setValue(data.voteAverage, forKey: "voteAverage")
                    movieItem.setValue(dataDetails?.genres?.first?.name, forKey: "genres")
                    movieItem.setValue(dataDetails?.releaseDate, forKey: "releaseDate")
                    movieItem.setValue(dataDetails?.runtime, forKey: "runtime")

                    do {
                        try context.save()
                        print("Saved to history")
                    } catch {
                        print("Failed to save item to history: \(error)")
                    }
                }
            }
        } catch {
            print("Error fetching existing movie: \(error)")
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
        //        hidesBottomBarWhenPushed = false
        // Show the tab bar when inside DetailViewController
        UINavigationBar.appearance().isHidden = false
    }
}
