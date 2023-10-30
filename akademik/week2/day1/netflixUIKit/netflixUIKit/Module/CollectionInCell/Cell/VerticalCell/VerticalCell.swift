//
//  CollectionCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class VerticalCell: UITableViewCell {

    @IBOutlet weak var myListLabel: UIButton!
    @IBOutlet weak var playLabel: UIButton!
    @IBOutlet weak var infoLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
