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
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupContainer()
        setupProfileImg()
    }
    
    func configure(with message: ChatMessage) {
        chatLabel.text = message.text
        chatContainerView.layer.cornerRadius = 10
                        
        // ChatBG; Ms.Flixy = gray, Fahmi = maroon
        if message.isMsFlixy == true{
            chatContainerView.backgroundColor = .darkGray
            profileImg.image = UIImage(named: "femaleAI")
            nameLabel.text = "Ms. Flixy"
            nameLabel.textColor = .systemPink
        } else {
            chatContainerView.backgroundColor = UIColor(named: "chatColor") //maroon
            profileImg.image = UIImage(systemName: "person.circle.fill")
            nameLabel.text = "Fahmi"
            nameLabel.textColor = .systemYellow
//            profileImg.removeFromSuperview()
        }

        // Set the time label to the current local device time
        timeLabel.text = formattedCurrentTime()
    }
    
    func setupProfileImg(){
        profileImg.image = UIImage(named: "femaleAI")
    }
    
    func setupContainer(){
        chatContainerView.makeCornerRadius(15, maskedCorners: [.topLeft, .topRight, .bottomRight])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Helper function to get the current time and format it as a string
    private func formattedCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

