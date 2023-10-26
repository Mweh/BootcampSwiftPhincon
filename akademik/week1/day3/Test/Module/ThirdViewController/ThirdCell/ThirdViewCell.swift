//
//  ThirdViewCell.swift
//  Test
//
//  Created by Muhammad Fahmi on 26/10/23.
//

import UIKit

class ThirdViewCell: UITableViewCell {

    @IBOutlet weak var laneAr: UIImageView!
    @IBOutlet weak var thirdCell: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        viewContainer.layer.cornerRadius = viewContainer.frame.size.width / 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
