//
//  ReviewsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import Kingfisher
import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    let index: Int
    let vm = SearchViewModel()
    
    var data: ResultNowPlaying?{
        didSet{
            tblView.reloadData()
        }
    }
    
    var dataReviews: Reviews?{
        didSet{
            tblView.reloadData()
        }
    }
    
    init(index: Int, data: ResultNowPlaying?) {
        self.index = index
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setupAPI()
    }
    
    func setupAPI(){
        if let data = data{
            self.vm.api.makeAPICall(endpoint: .getReviews(id: data.id)) { (response: Result<Reviews, Error>)  in
                switch response {
                case .success(let movieId):
                    self.dataReviews = movieId
                case .failure(let error):
                    print("Error fetching top rated movies: \(error)")
                }
            }
        }
    }
    
    func setUpTableView(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataReviews?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        if let data = dataReviews?.results?[indexPath.row]{
            cell.nameLabel.text = "@" + (data.author?.trimmingCharacters(in: .whitespaces).lowercased() ?? "N/A")
            cell.descLabel.text = data.content
            cell.descLabel.sizeToFit()
            cell.ratingLabel.text = data.authorDetails?.rating.map { "\($0)/10" } ?? "N/A"
            
            let defaultImageName = "questionmark"
            
            let tmdbImgBase = TMDBImageURL.url(size: .w92)

            let imageUrl = "\(tmdbImgBase)\(data.authorDetails?.avatarPath ?? "")"
            
            if let url = URL(string: imageUrl) {
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(systemName: defaultImageName)) { _ in
                    // Check if the loaded image is not the placeholder
                    if cell.profileImgView.image != UIImage(systemName: defaultImageName) {
                        cell.profileImgView.makeCornerRadius(25)
                        cell.profileImgView.contentMode = .scaleAspectFill
                    } else {
                        // Reset the corner radius if the loaded image is the placeholder
                        cell.profileImgView.layer.cornerRadius = 0
                    }
                }
            }
        }
        return cell
    }

}
