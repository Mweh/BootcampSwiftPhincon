//
//  SecondViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Kingfisher
import UIKit
import SkeletonView

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
//    private let refreshControl = UIRefreshControl()

    let customAPIManager = CustomAPIManager()
    
    var dataTopRated: TopRated? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData(){
        customAPIManager.makeAPICall(endpoint: .getTopRated) { (response: Result<TopRated, Error>)  in
            switch response {
            case .success(let topRated):
                self.dataTopRated = topRated
            case .failure(let error):
                // Handle the error
                print("Error fetching top rated movies: \(error)")
            }
        }
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListMovieCell", bundle: nil), forCellReuseIdentifier: "ListMovieCell")
    }
    
//    func configureRefreshControl () {
//        // Add the refresh control to your UIScrollView object.
//        myScrollingView.refreshControl = UIRefreshControl()
//        myScrollingView.refreshControl?.addTarget(self, action:
//                                                    #selector(handleRefreshControl),
//                                                  for: .valueChanged)
//    }
//
//    @objc func handleRefreshControl() {
//       // Update your content…
//
//
//       // Dismiss the refresh control.
//       DispatchQueue.main.async {
//          self.myScrollingView.refreshControl?.endRefreshing()
//       }
//    }
    
    @IBAction func buttonToSearchButtonVC(_ sender: Any) {
        let vc = SearchButtonViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataTopRated {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieCell", for: indexPath) as! ListMovieCell
            cell.setup(data: data.results[indexPath.row])
            let imageName = "https://image.tmdb.org/t/p/w500/\(data.results[indexPath.row].posterPath)"
            cell.imageFilm.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "hourglass"))
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
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
}
