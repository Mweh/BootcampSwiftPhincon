//
//  SimilarViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import Kingfisher
import UIKit

class SimilarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let vm = SearchViewModel()
    var movieId: Int?
    
    var dataResult: ResultNowPlaying?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var data: NowPlaying?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollection()
        setupAPI()
//        vm.loadData(for: .getSimilar(id: dataResult?.id ?? 100), resultType: NowPlaying.self)
    }

    init(dataResult: ResultNowPlaying?) {
        self.dataResult = dataResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAPI(){
        if let dataResult = dataResult{
            self.vm.api.makeAPICall(endpoint: .getSimilar(id: dataResult.id)) { (response: Result<NowPlaying, Error>)  in
                switch response {
                case .success(let movieId):
                    self.data = movieId
                case .failure(let error):
                    print("Error fetching top rated movies: \(error)")
                }
            }
        }
    }
    
    func setupCollection(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarCollectionViewCell")
    }
}

extension SimilarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as! SimilarCollectionViewCell
        if let data = data{
            let index = data.results[indexPath.row]
            let posterImgUrl = "https://image.tmdb.org/t/p/w200\(index.posterPath ?? "noImageURL")"
            let url = URL(string: posterImgUrl)
            cell.imgView.kf.setImage(with: url, placeholder: UIImage(named: "hourglass"))
            cell.titleLabel.text = index.title?.truncateToWords(3) ?? "N/A"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data?.results[indexPath.row] {
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailViewController.data = data
            detailViewController.hidesBottomBarWhenPushed = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width/3 - 18), height: 280 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 8, bottom: 10, right: 8)
    }
}
