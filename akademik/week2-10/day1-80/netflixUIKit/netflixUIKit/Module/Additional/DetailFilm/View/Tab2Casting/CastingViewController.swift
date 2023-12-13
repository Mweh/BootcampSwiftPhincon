//
//  CastingViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 20/11/23.
//

import UIKit

protocol CastingViewControllerDelegate: AnyObject {
    func updateMenu(total: Int)
}

class CastingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var loadingIndicator = PopUpLoading(on: view)
    
    let index: Int
    let vm = SearchViewModel()
    
    var data: ResultMovie?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    weak var delegate: CastingViewControllerDelegate?

    var dataCredit: Credit? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(index: Int, data: ResultMovie?, delegate: CastingViewControllerDelegate?) {
        self.index = index
        self.data = data
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.dismissImmediately()

        setupAPI()
        setupUICollection()
    }
    
    func setupAPI(){
        if let data = data{
            self.vm.api.makeAPICall(endpoint: .getCredits(id: data.id)) { (response: Result<Credit, Error>)  in 
                switch response {
                case .success(let creditId):
                    self.dataCredit = creditId
                    self.delegate?.updateMenu(total: creditId.cast.count)
                case .failure(let error):
                    print("Error fetching top rated movies: \(error)")
                }
            }
        }
    }
    
    func setupUICollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CastingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastingCollectionViewCell")
    }
}

extension CastingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCredit?.cast.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastingCollectionViewCell", for: indexPath) as! CastingCollectionViewCell
        let tmdbImgBase = TMDBImageURL.url(size: .w200)
        let actorImgUrl = "\(tmdbImgBase)\(dataCredit?.cast[indexPath.row].profilePath ?? "noImageURL")"
        let url = URL(string: actorImgUrl)
        cell.actorImgView.kf.setImage(with: url, placeholder: UIImage(named: "netflix"))
        cell.characterLabel.text = dataCredit?.cast[indexPath.row].character?.truncateToWords(2)
        cell.actorLabel.text = dataCredit?.cast[indexPath.row].name.truncateToWords(2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width/2 - 50), height: 200 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 40 , bottom: 10, right:40)
    }
}
