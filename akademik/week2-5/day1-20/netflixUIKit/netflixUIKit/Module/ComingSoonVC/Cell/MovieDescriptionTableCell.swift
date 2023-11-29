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

class MovieDescriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStackViewIcon: UIStackView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet var loremLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet weak var addToFavButton: UIButton!
    @IBOutlet weak var tappableFadedImageView: TappableFadedImageView!
    
    private var isFav = BehaviorRelay<Bool>(value: false)
    private var favoriteModel: ParamAddFavorite?
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerStyle()
        setupfavButton()
    }
    
    func containerStyle(){
        imgView.layer.borderWidth = 2.0
        imgView.layer.borderColor = UIColor.white.cgColor
        selectionStyle = .none
        containerStackViewIcon.makeCornerRadius(20, maskedCorner: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        imgView.makeCornerRadius(20, maskedCorner: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])

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
    
    func setup(data: ResultNowPlaying?, favoriteModel: ParamAddFavorite?) {
        if let validData = data {
            if let validData = data {
                popularityLabel.text = "Views: \(validData.popularity)"
                titileLabel.text = validData.title
                loremLabel.text = "Synopsis: \n\(validData.overview)"
                loremLabel.sizeToFit()
                loremLabel.preferredMaxLayoutWidth = loremLabel.bounds.width
                // Format releaseDate to a specific date format
                let dateString = formatDate(validData.releaseDate ?? "")
                releaseDateLabel.text = "Release date: \(dateString)"
    
            }
            // Update isFav based on the favorite status of the movie
            isFav.accept(favoriteModel?.favorite ?? false)
            
            // Handle tap on addToFavButton to update isFav and make API call
            addToFavButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.isFav.accept(!self.isFav.value)
                    
                    // Call the API to update the favorite status
                    self.updateFavoriteStatus(isFav: self.isFav.value, mediaId: validData.id)
                })
                .disposed(by: bag)
        }
    }
    
    // Helper function to update favorite status via API call
    private func updateFavoriteStatus(isFav: Bool, mediaId: Int) {
        // Create the ParamAddFavorite
        let param = ParamAddFavorite(mediaType: "movie", mediaId: mediaId, favorite: isFav)
        
        // Call the API to add to favorites
        CustomAPIManager.shared.addToFavorites(param: param) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                print("Added to favorites successfully: \(favorites)")
                
                // Update the favorite model
                self.favoriteModel?.favorite = isFav
            case .failure(let error):
                print("Failed to add to favorites: \(error)")
                
                // Revert the isFav state if the API call fails
                self.isFav.accept(!isFav)
            }
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
