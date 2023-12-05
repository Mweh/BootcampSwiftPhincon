//
//  HistoryTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/12/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeCornerRadius(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
