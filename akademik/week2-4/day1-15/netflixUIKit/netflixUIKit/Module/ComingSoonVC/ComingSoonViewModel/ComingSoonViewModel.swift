//
//  ComingSoonViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 13/11/23.
//

import Foundation
import RxCocoa
import RxSwift

class ComingSoonViewModel {
    private let apiManager = CustomAPIManager()

    var dataUpcoming = BehaviorRelay<Upcoming?>(value: nil)

    func loadData(page: Int = 1, completion: @escaping (Result<(), Error>) -> Void) {
        apiManager.makeAPICall(endpoint: .getUpcoming(page: page)) { [weak self] (response: Result<Upcoming, Error>) in
            guard let self = self else { return }

            switch response {
            case .success(let upcoming):
                if page == 1 {
                    self.dataUpcoming.accept(upcoming)
                } else {
                    var existingData = self.dataUpcoming.value
                    existingData?.results.append(contentsOf: upcoming.results)
                    self.dataUpcoming.accept(existingData)
                }
                completion(.success(()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadMoreData(completion: @escaping (Result<(), Error>) -> Void) {
        // Assuming you have a property tracking the current page in your ViewModel
        var nextPage = 1/* Calculate the next page based on your logic */
        nextPage += 1
        loadData(page: nextPage, completion: completion)
    }
}

/*
 //
 //  ComingSoonViewController.swift
 //  netflixUIKit
 //
 //  Created by Muhammad Fahmi on 31/10/23.
 //
 import Lottie
 import Kingfisher
 import RxSwift
 import SkeletonView
 import UIKit

 class ComingSoonViewController: UIViewController {
     
     @IBOutlet weak var tableView: UITableView!
     private let refreshControl = UIRefreshControl()
     private var animationView: LottieAnimationView?
     
     private let viewModel = ComingSoonViewModel()
     let bag = DisposeBag()

     var currentPage = 1 // Add this property
     
     var dataTable: Upcoming? {
         didSet {
             tableView.reloadData()
         }
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         configureTable()
         lottieConfig()
         bindViewModel()
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
     
     func bindViewModel() {
         viewModel.dataUpcoming
             .asDriver(onErrorJustReturn: nil)
             .drive(onNext: { [weak self] _ in
                 self?.tableView.reloadData()
             })
             .disposed(by: bag)
     }
     
     
     @objc private func handleRefreshControl() {
         viewModel.loadData() { [weak self] result in
             // Handle result if needed
             self?.refreshControl.endRefreshing()
         }
     }
     
     func loadMoreData() {
         viewModel.loadMoreData() { [weak self] result in
             // Handle result if needed
         }
     }
     
 }

 extension ComingSoonViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource{
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
         if let data = dataTable {
             let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDescriptionTableCell", for: indexPath) as! MovieDescriptionTableCell
             cell.setup(data: data.results[indexPath.row])
             
             let imageName = "https://image.tmdb.org/t/p/w500/\(data.results[indexPath.row].posterPath)"
             if let url = URL(string: imageName) {
                 cell.imgView.kf.indicatorType = .activity
                 cell.imgView.kf.setImage(with: url)
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
             self.loadMoreData()
         }
     }
 }

 */
