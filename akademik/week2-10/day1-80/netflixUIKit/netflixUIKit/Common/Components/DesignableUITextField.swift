//
//  DesignableUITextField.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/11/23.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    @IBInspectable
    var shakeMagnitude: CGFloat = 10.0

    @IBInspectable
    var shakeDuration: TimeInterval = 0.5

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, shakeMagnitude, -shakeMagnitude, shakeMagnitude, 0]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animation.duration = shakeDuration
        layer.add(animation, forKey: "shake")
    }

    func stopShaking() {
        layer.removeAnimation(forKey: "shake")
    }
    
    let passwordVisibilityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
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
    
//    override var intrinsicContentSize: CGSize {
//        return UIView.layoutFittingExpandedSize
//    }
    
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
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
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

//@IBDesignable
//class ShakingTextField: UITextField {
//
//    @IBInspectable
//    var shakeMagnitude: CGFloat = 10.0
//
//    @IBInspectable
//    var shakeDuration: TimeInterval = 0.5
//
//    func shake() {
//        let animation = CAKeyframeAnimation(keyPath: "position.x")
//        animation.values = [0, shakeMagnitude, -shakeMagnitude, shakeMagnitude, 0]
//        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
//        animation.duration = shakeDuration
//        layer.add(animation, forKey: "shake")
//    }
//
//    func stopShaking() {
//        layer.removeAnimation(forKey: "shake")
//    }
//
//    // Add any other customization or functionality you need for the UITextField
//}
//
//// Usage:
//// You can set the ShakingTextField class for your UITextField in the Interface Builder.
//// You can customize the shakeMagnitude and shakeDuration properties from the Attributes Inspector.