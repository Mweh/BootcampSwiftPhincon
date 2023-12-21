//
//  MsFlixyAssistanceTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 15/12/23.
//

import FirebaseAuth
import UIKit
import Lottie

class MsFlixyAssistanceTableViewCell: UITableViewCell {

    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImgUser: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var rightGreaterConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var rightLessConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var leftGreaterConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var leftLessConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var imgAndChatStackView: UIStackView!
    
    @IBOutlet weak var isTypingLottieView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupProfileImg()
        setupAnimation()
    }
    
    func setupAnimation() {
        isTypingLottieView.animation = LottieAnimation.named("loadingChatIndicator")
        isTypingLottieView.loopMode = .loop
        isTypingLottieView.play()
    }
    
    func configure(with message: ChatMessage) {
        chatLabel.text = message.text
              
        if let image = message.image {
            // Display the selected image
            photoImageView.image = image
            photoImageView.makeRounded(20)
        } else {
            // Hide the image view if there's no image
            photoImageView.image = nil
        }
        
        if message.isMsFlixy == true { // Ms. Flixy
            setupContainer(maskedCorners: [.topLeft, .topRight, .bottomRight])
            
            rightGreaterConstraintStackView.constant = 72
            rightLessConstraintStackView.constant = 1000
            leftGreaterConstraintStackView.constant = 8
            leftLessConstraintStackView.constant = 8
            
            isTypingLottieView.isHidden = false
            profileImgUser.isHidden = true
            profileImg.isHidden = false
            chatContainerView.backgroundColor = .darkGray
            imgAndChatStackView.alignment = .leading
            nameLabel.text = "Ms. Flixy"
            nameLabel.textColor = .systemPink
        } else {
            // Fahmi
            setupContainer(maskedCorners: [.topLeft, .topRight, .bottomLeft])
            
            rightGreaterConstraintStackView.constant = 8
            rightLessConstraintStackView.constant = 8
            leftGreaterConstraintStackView.constant = 72
            leftLessConstraintStackView.constant = 1000
            
            isTypingLottieView.isHidden = true
            profileImgUser.isHidden = false
            profileImg.isHidden = true
            chatContainerView.backgroundColor = UIColor(named: "chatColor") //maroon
            imgAndChatStackView.alignment = .trailing
            // Assuming you have an authentication state listener set up
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    let uid = user.uid
                    let email = user.email
                    
                    self.nameLabel.text = email
                }
            }
            
            nameLabel.textColor = .systemYellow
        }

        // Set the time label to the current local device time
        timeLabel.text = formattedTime(from: message.timestamp)
    }
    
    // Helper function to format a given timestamp as a string
    private func formattedTime(from timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    func setupProfileImg(){
        profileImg.image = UIImage(named: "femaleAI")
    }
    
    func setupContainer(maskedCorners: [CornerRadiusMask]){
        chatContainerView.makeCornerRadius(15, maskedCorners: maskedCorners)
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

