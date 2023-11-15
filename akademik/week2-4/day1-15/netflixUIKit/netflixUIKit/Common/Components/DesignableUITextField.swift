//
//  DesignableUITextField.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    let passwordVisibilityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    @IBInspectable var showPasswordButton: Bool = false {
        didSet {
            updatePasswordVisibilityButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatePasswordVisibilityButton()
    }
    
    private func updatePasswordVisibilityButton() {
        if showPasswordButton {
            rightViewMode = .always
            rightView = passwordVisibilityButton
        } else {
            rightViewMode = .never
            rightView = nil
        }
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        
        // Toggle the eye icon based on the secureTextEntry state
        let imageName = isSecureTextEntry ? "eye" : "eye.fill"
        passwordVisibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = .systemRed {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemGray])
    }
}
