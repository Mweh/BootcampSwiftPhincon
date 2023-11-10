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

class ComingSoonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var animationView: LottieAnimationView?
    
    let customAPIManager = CustomAPIManager()

    var dataTable: Upcoming? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        loadData()
        lottieConfig()
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
    
    func loadData(){
        tableView.showAnimatedGradientSkeleton()

        customAPIManager.makeAPICall(endpoint: .getUpcoming) { (response: Result<Upcoming, Error>)  in
            switch response {
            case .success(let upcoming):
                self.dataTable = upcoming
            case .failure(let error):
                // Handle the error
                print("Error fetching popular movies: \(error)")
            }
            self.tableView.hideSkeleton()
        }
    }
    
}

extension ComingSoonViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "MovieDescriptionTableCell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDescriptionTableCell", for: indexPath) as! MovieDescriptionTableCell
            cell.setup(data: data.results[indexPath.row])
            let imageName = "https://image.tmdb.org/t/p/w500/\(data.results[indexPath.row].posterPath)"
            cell.imgView.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "hourglass"))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
