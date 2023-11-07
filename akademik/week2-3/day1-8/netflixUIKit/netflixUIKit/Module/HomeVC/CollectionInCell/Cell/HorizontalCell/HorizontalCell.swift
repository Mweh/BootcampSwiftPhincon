//
//  TableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit
import Kingfisher



class HorizontalCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var typeCell: SectionCell = .CircleCell
    
    var collectionNowPlaying: [ResultNowPlaying] = []
    var collectionDiscoverTV: [ResultDiscoverTV] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
    
        setUp()
    }
    
    func setUp(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension HorizontalCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeCell {
        case .CircleCell:
            return collectionNowPlaying.count
        case .SquareCell:
            return collectionDiscoverTV.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch typeCell {
        case .CircleCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            self.titleLabel.text = typeCell.title
            if indexPath.row < collectionNowPlaying.count {
                let imageName = "https://image.tmdb.org/t/p/w500/\(collectionNowPlaying[indexPath.row].posterPath)"
                
                let url = URL(string: imageName)
                cell.movieImage.kf.setImage(with: url)
            }
            collectionViewHeightConstraint.constant = 50 // no effect, only in tableview changing
            return cell
        case .SquareCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as! SquareCollectionViewCell
            self.titleLabel.text = typeCell.title
            
            if indexPath.row < collectionDiscoverTV.count {
                let imageName = "https://image.tmdb.org/t/p/w500/\(collectionDiscoverTV[indexPath.row].posterPath)"
                
                let url = URL(string: imageName)
                cell.imgView.kf.setImage(with: url)
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch typeCell{ // how can I use this
        case .CircleCell:
            let cellWidth = 150 // Set your desired cell width
            let cellHeight = 150 // Set your desired cell height
            return CGSize(width: cellWidth, height: cellHeight)
        case .SquareCell:
            let cellWidth = 150 // Set your desired cell width
            let cellHeight = 250 // Set your desired cell height
            return CGSize(width: cellWidth, height: cellHeight)
        }
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
