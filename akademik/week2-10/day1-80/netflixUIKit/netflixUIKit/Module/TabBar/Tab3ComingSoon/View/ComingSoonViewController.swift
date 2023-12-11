//
//  ComingSoonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.

import Lottie
import Kingfisher
import RxSwift
import SkeletonView
import UIKit

class ComingSoonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var animationView: LottieAnimationView?
    
    let vm = ComingSoonViewModel()
    let bag = DisposeBag()
    
    var currentPage = 1
    
    var dataTable: Movie? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        loadData()
        lottieConfig()
        bindApiData()
        setupFloatinIcon()
    }
    
    func setupFloatinIcon(){
        // Add a floating icon with conditions to show or hide
        addFloatingIcon(useLottie: true, lottieFileName: "backToTop", iconSize: 100, trailingValue: 20, bottomValue: -60, showCloseButton: false)
    }
    
    override func floatingIconTapped() {
        // Add a function that when pressed makes your tableView scroll to the top
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vm.loadData(for: .getUpcoming(page: currentPage), resultType: Movie.self)
    }
    
    func bindApiData() {
        vm.loadData(for: .getUpcoming(page: 1), resultType: Movie.self)
        vm.dataMovie.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataTable = data
            self.tableView.reloadData()
        }).disposed(by: bag)
        vm.stateLoading.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .loading:
                self.tableView.showAnimatedGradientSkeleton()
            case .fisnished:
                self.tableView.hideSkeleton()
            }
        })
        .disposed(by: bag)
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieDescriptionTableCell", bundle: nil), forCellReuseIdentifier: "MovieDescriptionTableCell")
        // Add the refresh control to your UITableView.
        tableView.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func lottieConfig(){
        animationView = LottieAnimationView(name: "refreshDownArrow")
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        
        // Calculate an appropriate size for the animation view based on the device frame
        let screenSize = UIScreen.main.bounds.size
        let animationSize = min(screenSize.width, screenSize.height) * 0.2 // Adjust the multiplier as needed
        
        animationView?.frame = CGRect(x: 0, y: 0, width: animationSize, height: animationSize)
        
        // Ensure that animationView is not nil before adding it to the refreshControl
        if let animationView = animationView {
            refreshControl.subviews.forEach { $0.removeFromSuperview() } // Remove any existing subviews
            
            refreshControl.addSubview(animationView)
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: refreshControl.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: refreshControl.centerYAnchor),
                animationView.widthAnchor.constraint(equalToConstant: animationSize),
                animationView.heightAnchor.constraint(equalToConstant: animationSize)
            ])
            let textLabel = RefreshTextLabel.refreshTL()
            
            refreshControl.addSubview(textLabel)
            
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textLabel.centerXAnchor.constraint(equalTo: refreshControl.centerXAnchor),
                textLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 5) // Adjust the spacing as needed
            ])
        }
        
        
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefreshControl() {
        loadData()
        
        // Start the Lottie animation
        refreshControl.subviews.forEach { view in
            if let animationView = animationView {
                animationView.play()
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Update your data fetching logic here
            
            // Reload the table view and end refreshing
            self.tableView.reloadData()
            
            // Stop the Lottie animation
            self.refreshControl.subviews.forEach { view in
                if let animationView = self.animationView {
                    animationView.stop()
                }
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadData(page: Int = 1) {
        tableView.showAnimatedGradientSkeleton()
        
        self.vm.api.makeAPICall(endpoint: .getUpcoming(page: page)) { [weak self] (response: Result<Movie, Error>)  in
            guard let self = self else { return }
            
            switch response {
            case .success(let dataMovie):
                if page == 1 {
                    // For the initial load or refreshing, set the entire data
                    self.dataTable = dataMovie
                } else {
                    // For pagination, append the new data to the existing data
                    self.dataTable?.results.append(contentsOf: dataMovie.results)
                }
                
                self.tableView.reloadData()
            case .failure(let error):
                // Handle the error
                print("Error fetching upcoming movies: \(error)")
            }
            self.tableView.hideSkeleton()
        }
    }
    // Handle tap gesture
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // Get the movie ID from the tapped cell
        let movieId = sender.view?.tag ?? 0
        
        // Perform navigation to another view using the movie ID
        let videoTrailerVC = VideoTrailerVC(nibName: "VideoTrailerVC", bundle: nil)
        // Pass the movie ID to the next view controller
        videoTrailerVC.hidesBottomBarWhenPushed = true
        videoTrailerVC.movieId = movieId
        navigationController?.pushViewController(videoTrailerVC, animated: true)
    }
}

extension ComingSoonViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable?.results.count ?? 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "MovieDescriptionTableCell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable?.results.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = self.dataTable?.results {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDescriptionTableCell", for: indexPath) as! MovieDescriptionTableCell
            // Assuming you have the necessary information to create a ParamAddFavorite instance
            let favoriteModel = ParamAddFavorite(mediaType: "movie", mediaId: data[indexPath.row].id, favorite: false)
            
            cell.setup(data: data[indexPath.row], favoriteModel: favoriteModel) //Missing argument for parameter 'favoriteModel' in call
            let backDropPath = data[indexPath.row].backdropPath ?? ""
            let tmdbImgBase = TMDBImageURL.url(size: .w780)
            
            let imageName = "\(tmdbImgBase)\(backDropPath)"
            if let url = URL(string: imageName) {
                cell.imgView.kf.indicatorType = .activity
                cell.imgView.kf.setImage(with: url, placeholder: UIImage(systemName: "hourglass"))
            }
            print("Image URL: \(imageName)")
            
            // Add a tap gesture recognizer to cell.movieImage
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            cell.tappableFadedImageView.addGestureRecognizer(tapGesture)
            
            // Set tag to the movie ID for later retrieval
            cell.tappableFadedImageView.tag = data[indexPath.row].id
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (dataTable?.results.count ?? 0) - 1 {
            // You are at the last cell, load more data
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        // Increment the page number or take any action needed to load the next set of data
        currentPage += 1
        // Call the common loadData method with the updated page number
        loadData(page: currentPage)
    }
}
