//
//  SeeAllViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 27/11/23.
//

import UIKit
import Kingfisher

class SeeAllViewController: UIViewController {

    @IBOutlet weak var seeAllCollectionView: UICollectionView!
    
    var dataMovie: [ResultMovie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if let dataMovie = dataMovie {
            seeAllCollectionView.reloadData()
        }
    }
    
    func setup(){
        seeAllCollectionView.dataSource = self
        seeAllCollectionView.delegate = self
        seeAllCollectionView.register(UINib(nibName: "SeeAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SeeAllCollectionViewCell")
    }
}

extension SeeAllViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataMovie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validData = dataMovie {
            let cell = seeAllCollectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCollectionViewCell", for: indexPath) as! SeeAllCollectionViewCell
            if let posterPath = validData[indexPath.row].posterPath {
                cell.setup(imageName: posterPath)
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width/2 - 50), height: 200 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 40 , bottom: 10, right:40)
    }
    
}
