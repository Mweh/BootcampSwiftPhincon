//
//  MsFlixyAssistanceTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 15/12/23.
//

import UIKit

class MsFlixyAssistanceTableViewCell: UITableViewCell {

    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupContainer()
        setupProfileImg()
    }
    
    func setupProfileImg(){
        profileImg.image = UIImage(named: "femaleAI")
    }
    
    func setupContainer(){
        chatContainerView.makeCornerRadius(15, maskedCorners: [.topLeft, .topLeft, .bottomRight])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
