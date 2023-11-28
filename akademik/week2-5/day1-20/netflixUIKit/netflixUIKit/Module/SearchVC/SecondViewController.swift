//
//  SecondViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Hero
import Lottie
import Kingfisher
import RxSwift
import SkeletonView
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var animationView: LottieAnimationView?
    var isDataLoaded: Bool = false
    
    let vm = SearchViewModel()
    let bag = DisposeBag()
    
    var dataTopRated: NowPlaying? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        lottieConfig()
        bindApiData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        vm.loadData(for: .getNowPlaying, resultType: NowPlaying.self)
    }
    
    func bindApiData() {
        vm.dataNowPlaying.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataTopRated = data
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
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListMovieCell", bundle: nil), forCellReuseIdentifier: "ListMovieCell")
        
        // Add the refresh control to your UITableView.
        tableView.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefreshControl() {
        vm.loadData(for: .getNowPlaying, resultType: NowPlaying.self)
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
    
    @IBAction func buttonToSearchButtonVC(_ sender: Any) {
        let vc = SearchButtonViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SecondViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTopRated?.results.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "ListMovieCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTopRated?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataTopRated {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieCell", for: indexPath) as! ListMovieCell
            cell.setup(data: data.results[indexPath.row])
            let imageName = "https://image.tmdb.org/t/p/w500/\(data.results[indexPath.row].backdropPath ?? "")"
            cell.imageFilm.kf.indicatorType = .activity
            cell.imageFilm.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "hourglass"))
            cell.imageFilm.hero.id = "\(data.results[indexPath.row].backdropPath ?? "")"
            cell.imageFilm.sizeToFit()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedData = dataTopRated?.results[indexPath.row] {
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailViewController.data = selectedData
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
