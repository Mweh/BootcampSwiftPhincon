//
//  DateUIHeaderView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/01/24.
//

import UIKit

// MARK: -- UITableViewHeaderFooterView for DateUIHeaderView
// A custom UITableViewHeaderFooterView for displaying a centered UILabel as the header view.
class DateUIHeaderView: UITableViewHeaderFooterView {
    
    // UILabel for displaying the header text.
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // Initialize the header view with a reuseIdentifier.
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI() // Call the setupUI method to configure the UI.
    }
    
    // Required initializer for NSCoder. Not implemented, as this class is not meant to be loaded from a nib or storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the UI by adding the label as a subview to the contentView.
    private func setupUI() {
        contentView.addSubview(label)
    }
    
    // Adjust the layout of the label to fill the contentView when the view's bounds change.
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
