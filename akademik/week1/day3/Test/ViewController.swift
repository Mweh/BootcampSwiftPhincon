//
//  ViewController.swift
//  Test
//
//  Created by Muhammad Fahmi on 25/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var emailBorder: UIView!
    @IBOutlet weak var phoneBorder: UIView!
    @IBOutlet weak var companyBorder: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.setImage(fromURL: "https://tinyurl.com/yxdqvz88") // Steve jobs
        
        emailBorder.addBorder()
        phoneBorder.addBorder()
        companyBorder.addBorder()
        
        viewBottom.layer.cornerRadius = self.viewBottom.frame.size.width / 10
    }
}

extension UIView {
    func addBorder() {
        self.layer.borderWidth = 0.5 // Adjust the width as needed
        self.layer.cornerRadius = self.frame.size.width / 30
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
    }
}

extension UIImageView {
    func setImage(fromURL imageURL: String) {
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.layer.cornerRadius = (self?.frame.size.width)!/2
                        self?.clipsToBounds = true
                        self?.layer.borderWidth = 2.0 // Adjust the width as needed
                        self?.layer.borderColor = UIColor.white.cgColor // Adjust the color as needed
                    }
                }
            }.resume()
        }
    }
}


