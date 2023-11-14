//
//  ComingSoonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//
import Lottie
import Kingfisher
import SkeletonView
import UIKit

class FavHomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var animationView: LottieAnimationView?
    
    let customAPIManager = CustomAPIManager()
    
    var currentPage = 1 // Add this property
    
    var dataTable: Favorites? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        loadData()
        lottieConfig()
        tableView.delegate = self
        showNaviItem()
    }
    
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
    
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavHomeViewCell", bundle: nil), forCellReuseIdentifier: "FavHomeViewCell")
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
        
        customAPIManager.makeAPICall(endpoint: .getFavorite(page: page)) { [weak self] (response: Result<Favorites, Error>)  in
            guard let self = self else { return }
            
            switch response {
            case .success(let favorites):
                if page == 1 {
                    // For the initial load or refreshing, set the entire data
                    self.dataTable = favorites
                } else {
                    // For pagination, append the new data to the existing data
                    self.dataTable?.results.append(contentsOf: favorites.results)
                }
                
                self.tableView.reloadData()
            case .failure(let error):
                // Handle the error
                print("Error fetching upcoming movies: \(error)")
            }
            
            self.tableView.hideSkeleton()
        }
    }
    
}

extension FavHomeVC: SkeletonTableViewDelegate, SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable?.results.count ?? 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "FavHomeViewCell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable?.results.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavHomeViewCell", for: indexPath) as! FavHomeViewCell
            cell.setup(data: data.results[indexPath.row])
            
            let imageName = "https://image.tmdb.org/t/p/w500/\(data.results[indexPath.row].posterPath)"
            if let url = URL(string: imageName) {
                cell.imgView.kf.indicatorType = .activity
                cell.imgView.kf.setImage(with: url, placeholder: UIImage(systemName: "hourglass")) { result in
                    switch result {
                    case .success(_):
                        print("Image loaded successfully.")
                    case .failure(let error):
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
            print("Image URL: \(imageName)")
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
