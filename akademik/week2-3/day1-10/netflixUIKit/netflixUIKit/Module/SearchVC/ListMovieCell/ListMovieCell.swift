//
//  ListMovieCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import UIKit
import Kingfisher

class ListMovieCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageFilm: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = containerView.frame.height / 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: ResultTopRated?) {
        if let validData = data {
            titleLabel.text = validData.title
        }
    }
}
