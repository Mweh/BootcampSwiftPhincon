//
//  HistoryViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/12/23.
//

import CoreData
import Kingfisher
import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var dataHistoryMovie: [HistoryModelMovie]?{
        didSet{
            tblView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataHistoryMovie?.removeAll()
        fetchCoreData()
    }
    
    func setupTable(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    func fetchCoreData() {
        var historyMovies: [HistoryModelMovie] = []

        // Fetch history movies from CoreDataHelper
        if let movieItems = CoreDataHelper.shared.fetchHistoryMovies() {
            historyMovies = movieItems
        }

        // Reverse the array to have the latest added item at the top
        historyMovies.reverse()

        // Assign the array of history movies to dataHistoryMovie
        dataHistoryMovie = historyMovies
        tblView.reloadData()

        let totalMovies = historyMovies.count
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistoryMovie?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataHistoryMovie?[indexPath.row]{
            let cell = tblView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
            
            let imgName = data.posterPath
            let url = URL(string: TMDBImageURL.url(size: .w154)+imgName)
            
            cell.imgView.kf.setImage(with: url)
            cell.titleLabel.text = data.title
            cell.ratingLabel.setSystemSymbol("star", withColor: .systemOrange, withAdditionalText: String(format: "%.1f", data.voteAverage))
            cell.genreLabel.setSystemSymbol("ticket", withAdditionalText: data.genres)
            //            cell.genreLabel.text = data.genres
            cell.yearLabel.setSystemSymbolWithFormattedDate("calendar", date: data.releaseDate, format: "yyyy")
            cell.minutesLabel.animateCountingHour(to: data.runtime, systemName: "clock")
        }
        return UITableViewCell()
    }
    
    // Enable swipe-to-delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the corresponding data from Core Data
            guard let movieId = dataHistoryMovie?[indexPath.row].id else {
                return
            }
            
            // Remove the corresponding item from the data array
            dataHistoryMovie = dataHistoryMovie?.filter { $0.id != movieId }
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let selectedData = dataHistoryMovie?[indexPath.row] {
//            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
//            detailViewController.movieId = selectedData.id
//            detailViewController.isFor = .isForHistory
//            detailViewController.hidesBottomBarWhenPushed = true
//            //        self.navigationController?.hero.isEnabled = true
//            navigationController?.pushViewController(detailViewController, animated: true)
//        }
//    }
}
