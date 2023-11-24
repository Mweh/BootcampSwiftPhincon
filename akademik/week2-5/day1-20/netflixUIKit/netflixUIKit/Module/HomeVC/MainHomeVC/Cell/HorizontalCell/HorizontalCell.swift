//
//  TableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Hero
import UIKit
import Kingfisher

protocol HorizontalCellDelegate: AnyObject {
    func didTapCellCircle(index: Int)
    func didTapCellSquare(index: Int)
}

class HorizontalCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var parentNavigationController: UINavigationController?
    
    var typeCell: SectionCell = .CircleCell
    weak var delegate: HorizontalCellDelegate?
    
    var collectionNowPlaying: [ResultNowPlaying]?
    var collectionDiscoverTV: [ResultNowPlaying]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        setUp()
    }
    
    func setUp(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
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
            return collectionNowPlaying?.count ?? 1
        case .SquareCell:
            return collectionDiscoverTV?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        switch typeCell {
        case .CircleCell:
            delegate?.didTapCellCircle(index: indexPath.row)
        case .SquareCell:
            delegate?.didTapCellSquare(index: indexPath.row)
            //            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch typeCell {
        case .CircleCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            if indexPath.row < collectionNowPlaying?.count ?? 1 {
                self.titleLabel.text = typeCell.title
                let imageName = "https://image.tmdb.org/t/p/w500/\(collectionNowPlaying?[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageName)
                cell.movieImage.kf.setImage(with: url)
                collectionViewHeightConstraint.constant = 50
            }
            
            return cell
        case .SquareCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as! SquareCollectionViewCell
            self.titleLabel.text = typeCell.title
            
            if indexPath.row < collectionDiscoverTV?.count ?? 1 {
                let imageName = "https://image.tmdb.org/t/p/w500/\(collectionDiscoverTV?[indexPath.row].posterPath ?? "")"
                
                let url = URL(string: imageName)
                cell.imgView.kf.setImage(with: url)
                cell.imgView.hero.id = "\(collectionDiscoverTV?[indexPath.row].posterPath ?? "")"
                print(collectionDiscoverTV?[indexPath.row].posterPath)
                
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
                    let urlName = "https://image.tmdb.org/t/p/w500/\(self?.collectionDiscoverTV?[indexPath.row].posterPath ?? "")"
                    
                    let url = URL(string: urlName)
                    self?.downloadImageURL(imageURL: url!)
                    // Assuming imageURL is the URL of the downloaded image
                    PhotoLibraryManager.saveImageToPhotos(url: url!) { error in
                        if let error = error {
                            print("Error saving image: \(error.localizedDescription)")
                        } else {
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
