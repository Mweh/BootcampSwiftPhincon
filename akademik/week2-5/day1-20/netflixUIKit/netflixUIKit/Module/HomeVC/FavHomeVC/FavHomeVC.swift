//
//  FavHomeVC.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import RxSwift
import UIKit

class FavHomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataFavoriteNoPaging: Favorites? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var vm = HomeViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bindData()
        vm.loadData(for: .getFavoriteNoPaging, resultType: Favorites.self)
        showNaviItem()
    }
    
    func configure(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FavHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavHomeCollectionViewCell")
        self.navigationItem.title = "My Favorites Movie"
    }
    
    func bindData() {
        vm.dataFavoriteNoPaging.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataFavoriteNoPaging = data
            self.collectionView.reloadData()
        }).disposed(by: bag)
        
        vm.dataFavoriteNoPaging.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataFavoriteNoPaging = data
            self.collectionView.reloadData()
        }).disposed(by: bag)
    }
}

extension FavHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataFavoriteNoPaging?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        if let data = dataFavoriteNoPaging{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavHomeCollectionViewCell", for: indexPath) as! FavHomeCollectionViewCell
        //
        let imageName = "https://image.tmdb.org/t/p/w500/\(dataFavoriteNoPaging?.results[indexPath.row].posterPath ?? "" )"
        print("Image URL: \(imageName)") // Add this line to print the URL to the console
        let url = URL(string: imageName)
        cell.imgView.kf.setImage(with: url)
        //            return cell
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: (screenWidth/2)-7, height: 240)
    }
    
}

extension FavHomeVC{
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
}
