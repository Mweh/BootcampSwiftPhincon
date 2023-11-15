//
//  SearchButtonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/11/23.
//

import Kingfisher
import Lottie
import RxCocoa
import RxSwift
import UIKit

class SearchButtonViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    
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
//        settextFieldSearchInsideNavItem()
        setupAnimation()
        configure()
    }
    
    func settextFieldSearchInsideNavItem() {
        
        // Create the custom view with the container view
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 40)) //takes no effect
        customView.addSubview(textFieldSearch)
        
        // Set the custom view as the title view
        self.navigationItem.titleView = customView
    }
    
    
    func setupAnimation() {
        animationView.animation = LottieAnimation.named("movieLoading")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        // Bind the text field's text to the searchSubject
        textFieldSearch.rx.text.orEmpty
            .bind(to: searchSubject)
            .disposed(by: disposeBag)
        
        // Observer for changes in the text field's content
        textFieldSearch.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] _ in
                self?.updatePlaceholderVisibility()
            })
            .disposed(by: disposeBag)
        
        // Use the searchSubject to trigger the network request
        searchSubject
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query: String) -> Observable<SearchResponse> in
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
        // Initial update of placeholder visibility
        updatePlaceholderVisibility()
    }
    
    // Function to update the visibility of the placeholder view based on the text field input
    private func updatePlaceholderVisibility() {
        let isEmpty = textFieldSearch.text?.isEmpty ?? true
        animationView.isHidden = !isEmpty
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedMovie = searchResults?.results?[indexPath.row] {
            let videoTrailerVC = VideoTrailerVC(nibName: "VideoTrailerVC", bundle: nil)
            videoTrailerVC.hidesBottomBarWhenPushed = true
            
            // Pass the movie ID to the VideoTrailerVC
            videoTrailerVC.movieId = selectedMovie.id
            
            navigationController?.pushViewController(videoTrailerVC, animated: true)
        }
    }
}

class ContentContainerViewController: UIViewController {
    
    let contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentContainer()
    }
    
    func setupContentContainer() {
        view.addSubview(contentContainerView)
        // Adjust the frame of contentContainerView to position it beside the navigation item
        // You may also want to consider safe area insets
        contentContainerView.frame = CGRect(x: 20, y: 40, width: view.bounds.width, height: view.bounds.height)
    }
}