//
//  TableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class HorizontalCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageNames: [String] {
        return (1...10).map { "movie\($0)" } // Generates ["movie1", "movie2", ..., "movie20"]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension HorizontalCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.label.text = "Cell\(indexPath.row)"
        
        // Assuming you have an array of image names (e.g., "movie1", "movie2", etc.)

        if indexPath.row < imageNames.count {
            let imageName = imageNames[indexPath.row]
            cell.movieImage.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 150 // Set your desired cell width
        let cellHeight = 150 // Set your desired cell height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
