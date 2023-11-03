//
//  ComingSoonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//

import UIKit
import Kingfisher

class ComingSoonViewController: UIViewController {
    
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
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieDescriptionTableCell", bundle: nil), forCellReuseIdentifier: "MovieDescriptionTableCell")
    }
    
    func loadData(){
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
    
}

extension ComingSoonViewController: UITableViewDelegate, UITableViewDataSource{
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
