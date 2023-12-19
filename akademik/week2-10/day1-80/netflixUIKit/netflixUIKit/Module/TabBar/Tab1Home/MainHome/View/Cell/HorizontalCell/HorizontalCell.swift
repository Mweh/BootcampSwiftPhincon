//
//  TableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Hero
import Kingfisher
import RxCocoa
import RxSwift
import UIKit

protocol HorizontalCellDelegate: AnyObject {
    func didTapCellCircle(index: Int)
    func didTapCellSquare(index: Int)
}

class HorizontalCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var parentNavigationController: UINavigationController?
    var typeCell: SectionCell = .CircleCell
    
    weak var delegate: HorizontalCellDelegate?
    
    var collectionMovieNowPlaying: [ResultMovie]? {
        didSet{
            collectionView.reloadData()
        }
    }
    var collectionMoviePopular: [ResultMovie]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setUpSeeAll()
    }
    
    func setUpSeeAll(){
        seeAllButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.handleShowAll()
            })
            .disposed(by: bag)
    }
    
    private func handleShowAll(){
        switch typeCell {
        case .CircleCell:
            print("CircleCell in handleShowAll")
            showAllForCircleCell()
        case .SquareCell:
            print("SquareCell in handleShowAll")
            showAllForSquareCell()
        }
    }
    
    private func showAllForCircleCell() {
        // Example: Push a new view controller for "Show All" in CircleCell
        let seeAllVC = SeeAllViewController()
        seeAllVC.dataMovie = collectionMovieNowPlaying
        parentNavigationController?.present(seeAllVC, animated: true)
    }
    
    private func showAllForSquareCell() {
        // Example: Push a new view controller for "Show All" in CircleCell
        let seeAllVC = SeeAllViewController()
        seeAllVC.dataMovie = collectionMoviePopular
        parentNavigationController?.present(seeAllVC, animated: true)
    }
    
    func setUp(){
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        if #available(iOS 15.0, *) {
            collectionView.dataSource = self
            collectionView.delegate = self
        } else {
            // Fallback on earlier versions
        }
        // Add a tap gesture recognizer for didSelect functionality
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    // Handle tap on collectionView
    @objc private func collectionViewTapped(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func downloadImageURL(imageURL: URL){
        CustomAPIManager.shared.downloadImage(imageURL: imageURL) { result in
            switch result {
            case .success(let data):
                // Handle downloaded image data
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("Image downloaded successfully: \(data)")
            case .failure(let error):
                // Handle download failure
                print("Error downloading image: \(error)")
            }
        }
    }
}

@available(iOS 15.0, *)
extension HorizontalCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeCell {
        case .CircleCell:
            return collectionMovieNowPlaying?.count ?? 1
        case .SquareCell:
            return collectionMoviePopular?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        switch typeCell {
        case .CircleCell:
            delegate?.didTapCellCircle(index: indexPath.row)
        case .SquareCell:
            delegate?.didTapCellSquare(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch typeCell {
        case .CircleCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            if indexPath.row < collectionMovieNowPlaying?.count ?? 1 {
                let tmdbImgBase = TMDBImageURL.url(size: .w342)
                let imageName = "\(tmdbImgBase)\(collectionMovieNowPlaying?[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageName)
                cell.movieImage.kf.setImage(with: url)
                self.titleLabel.text = typeCell.title
                collectionViewHeightConstraint.constant = 50
            }
            
            return cell
        case .SquareCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as! SquareCollectionViewCell
            self.titleLabel.text = typeCell.title
            
            if indexPath.row < collectionMoviePopular?.count ?? 1 {
                let tmdbImgBase = TMDBImageURL.url(size: .w500)
                let imageName = "\(tmdbImgBase)\(collectionMoviePopular?[indexPath.row].posterPath ?? "")"
                
                let url = URL(string: imageName)
                cell.imgView.kf.setImage(with: url)
//                cell.imgView.hero.id = "\(collectionDiscoverTV?[indexPath.row].posterPath ?? "")"
                
                // Set ratedNumberLabel only for the first 9 cells
                (indexPath.row < 9) ? (cell.ratedNumberLabel.text = "\(indexPath.row + 1)") : (cell.ratedNumberLabel.text = nil)
            }
            
            // Show containerNewMovie only in the first cell
            if indexPath.row == 0 {
                cell.containerNewMovie.isHidden = false
                cell.tagTop10Img.isHidden = false
                
            } else if indexPath.row >= 9 {
                cell.containerNewMovie.isHidden = false
                cell.tagTop10Img.isHidden = true
            }
            else {
                cell.containerNewMovie.isHidden = true
                cell.tagTop10Img.isHidden = false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch typeCell{
        case .CircleCell:
            let cellWidth = 150
            let cellHeight = 150
            return CGSize(width: cellWidth, height: cellHeight)
        case .SquareCell:
            let cellWidth = 200
            let cellHeight = 250
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let tmdbImgBase = TMDBImageURL.url(size: .w342)
                    
                    let urlPath = (self?.typeCell == .CircleCell) ? self?.collectionMovieNowPlaying?[indexPath.row].posterPath ?? "" : self?.collectionMoviePopular?[indexPath.row].posterPath ?? ""
                    
                    let urlName = "\(tmdbImgBase)\(urlPath)"
                    let url = URL(string: urlName)
                    self?.downloadImageURL(imageURL: url!)
                    // Assuming imageURL is the URL of the downloaded image
                   
                        PhotoLibraryManager.saveImageToPhotos(url: url!) { error in
                            if let error = error {
                                print("Error saving image: \(error.localizedDescription)")
                            } else {
                                // Post a notification to notify other parts of the app about the tap
                                NotificationCenter.default.post(name: .cellSquareTapped, object: nil)
                                print("Image saved successfully.")
                            }
                        }
                    
                    
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}

enum SectionCell: Int, CaseIterable {
    case CircleCell
    case SquareCell
    
    var title: String{
        switch self{
        case .CircleCell:
            return "Previews"
        case .SquareCell:
            return "Popular on Netflix"
        }
    }
}
