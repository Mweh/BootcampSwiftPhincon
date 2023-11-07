//
//  CollectionCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import Kingfisher
import UIKit

class VerticalCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageAutoCarousel: UIPageControl!
    @IBOutlet weak var myListLabel: UIButton!
    @IBOutlet weak var playLabel: UIButton!
    @IBOutlet weak var infoLabel: UIButton!
    
    var images = (1...7).compactMap { UIImage(named: "movie\($0)") }
    var timer: Timer?
    var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerStackView.layer.cornerRadius = containerStackView.frame.height / 5
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        setUpCollection()
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
    }
}

extension VerticalCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.imgView.image = images[indexPath.item]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentIndex = Int(collectionView.contentOffset.x / pageWidth)
        pageAutoCarousel.currentPage = currentIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 372 // Set your desired cell width
        let cellHeight = 372 // Set your desired cell height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentIndex = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageAutoCarousel.currentPage = currentIndex
    }
}
