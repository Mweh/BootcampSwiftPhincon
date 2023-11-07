//
//  CollectionCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Kingfisher
import UIKit

class VerticalCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageAutoCarousel: UIPageControl!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var myListLabel: UIButton!
    @IBOutlet weak var playLabel: UIButton!
    @IBOutlet weak var infoLabel: UIButton!
    
    let images = [UIImage(named: "movie1"), UIImage(named: "movie2"), UIImage(named: "movie3")]
    var timer: Timer?
    var currentIndex = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // Initialization code
        setUpCollection()
        if let url = URL(string: "https://www.themoviedb.org/t/p/w500/w3cF2E269oUQIFq4IhRQ5MfkwMY.jpg") {
            imageMovie.kf.setImage(with: url)
            imageMovie.sizeToFit()
        }
        pageAutoCarousel.numberOfPages = images.count
        startAutoSlide()
    }
    
    func setUpCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        
    }
    
    func startAutoSlide() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoSlide), userInfo: nil, repeats: true)
    }
    
    @objc func autoSlide() {
        let nextIndex = (currentIndex + 1) % images.count
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentIndex = nextIndex
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

extension VerticalCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.imgView.image = images[indexPath.item]
        return cell // no cell show
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentIndex = Int(collectionView.contentOffset.x / pageWidth)
        pageAutoCarousel.currentPage = currentIndex
    }
}
