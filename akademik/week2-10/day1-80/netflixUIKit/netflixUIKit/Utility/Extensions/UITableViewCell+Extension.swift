//
//  UITableViewCell+Extension.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/12/23.
//

import Foundation
import UIKit

extension UITableViewCell {
    func addBadge(count: Int) {
        // Remove existing badge views
        self.contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        
        // Create a label for the badge
        let badgeLabel = UILabel()
        badgeLabel.text = "\(count)"
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.layer.masksToBounds = true
        badgeLabel.tag = 999 // Set a tag to identify the badge view later
        
        // Adjust the frame based on your cell's layout
        let badgeSize: CGFloat = 20
        let badgeOrigin = CGPoint(x: self.contentView.bounds.width - badgeSize - 24, y: self.contentView.bounds.height/3)
        badgeLabel.frame = CGRect(origin: badgeOrigin, size: CGSize(width: badgeSize, height: badgeSize))
        
        // Add the badge label to the cell's contentView
        self.contentView.addSubview(badgeLabel)
    }
    
    func removeBadge() {
        // Remove existing badge views
        self.contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
    }
}
