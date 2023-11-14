//
//  MovieDescriptionTableCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 03/11/23.
//
import Kingfisher
import RxSwift
import RxCocoa
import SkeletonView
import UIKit

class FavHomeViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStackViewIcon: UIStackView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet var loremLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet weak var addToFavButton: UIButton!
    
    private var isFav = BehaviorRelay<Bool>(value: false)
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerStyle()
        setupfavButton()
    }
    
    func containerStyle(){
        containerStackViewIcon.layer.cornerRadius = containerStackViewIcon.frame.height / 10
        imgView.layer.borderWidth = 2.0
        imgView.layer.borderColor = UIColor.white.cgColor
        
        selectionStyle = .none
        imgView.layer.cornerRadius = imgView.frame.height / 10
    }
    
    func setupfavButton(){
        addToFavButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.isFav.accept(!(self?.isFav.value ?? false))
            })
            .disposed(by: bag)
        
        isFav
            .subscribe(onNext: {[weak self] isFav in
                let imageName = isFav ? "star.fill" : "star"
                let image = UIImage(systemName: imageName)
                self?.addToFavButton.setImage(image, for: .normal)
                self?.addToFavButton.tintColor = isFav ? .red : .secondaryLabel
                
            })
            .disposed(by: bag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: ResultFavorites?) {
        if let validData = data {
            popularityLabel.text = "Popularity: \(validData.popularity)"
            titileLabel.text = validData.title
            loremLabel.text = "Synopsis: \n\(validData.overview)"
            loremLabel.sizeToFit()
            loremLabel.preferredMaxLayoutWidth = loremLabel.bounds.width
            // Format releaseDate to a specific date format
            let dateString = formatDate(validData.releaseDate)
            releaseDateLabel.text = "Release date: \(dateString)"
        }
    }
    
    // Helper function to format date
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of the date from the API
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM dd, yyyy" // Desired format
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
