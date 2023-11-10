//
//  SearchButtonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/11/23.
//

import Kingfisher
import UIKit
import RxSwift
import RxCocoa

class SearchButtonViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var searchResults: SearchResponse?  {
        didSet {
            self.collectionView.reloadData()
        }
    }
    // Update the data source for your collection view
    let disposeBag = DisposeBag() // Create a DisposeBag to manage disposables
    
    let apiManager = CustomAPIManager.shared
    
    // Create a BehaviorRelay to hold the search query
    var searchSubject: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        bindSearchTextFieldTo
    }
    
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        // Bind the text field's text to the searchSubject
        textFieldSearch.rx.text.orEmpty
            .bind(to: searchSubject)
            .disposed(by: disposeBag)
        
        // Use the searchSubject to trigger the network request
        searchSubject
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query: String) -> Observable<SearchResponse> in // ngambil sequence yg terakhir
                return Observable.create { observer in
                    self.apiManager.makeAPICall(endpoint: .searchMovie(query: query)){ (result: Result<SearchResponse, Error>) in
                        switch result {
                        case .success(let movies):
                            observer.onNext(movies)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { [weak self] (results: SearchResponse ) in
                self?.searchResults = results
            })
            .disposed(by: disposeBag)
    }
}

extension SearchButtonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let validCount = self.searchResults?.results?.count ?? 0
        return validCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validData = self.searchResults?.results {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            if let urlString = validData[indexPath.row].posterPath {
                let imageName = "https://image.tmdb.org/t/p/w500/\(urlString)"
                let url = URL(string: imageName)
                cell.imgView.kf.setImage(with: url)
            }
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
}
