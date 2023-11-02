//
//  SecondViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataTable: TMDBResponse? {
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
        UINavigationBar.appearance().isHidden = true
    }
    
    func loadData() {
        APIManager.fetchPopularMovies { result in
            switch result {
            case .success(let tmdbResponse):
                self.dataTable = tmdbResponse
            case .failure(let error):
                // Handle the error
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListMovieCell", bundle: nil), forCellReuseIdentifier: "ListMovieCell")
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieCell", for: indexPath) as! ListMovieCell
            cell.setup(data: data.results[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedData = dataTable?.results[indexPath.row] {
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailViewController.data = selectedData
            navigationController?.pushViewController(detailViewController, animated: true)
            UINavigationBar.appearance().isHidden = false
        }
    }

}
