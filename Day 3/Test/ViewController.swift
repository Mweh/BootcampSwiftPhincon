//
//  ViewController.swift
//  Test
//
//  Created by Muhammad Fahmi on 25/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mailInfo: UILabel!
    
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
    
        image(imageLink: "https://tinyurl.com/yxdqvz88") // Steve jobs
        borderFrame(border: emailBorder)
        borderFrame(border: phoneBorder)
        borderFrame(border: companyBorder)

        mailInfo.text = "stvejobs@apple.com"
        viewBottom.layer.cornerRadius = self.viewBottom.frame.size.width / 10
    }
    
    func image(imageLink: String){
        if let imageURL = URL(string: imageLink) {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageProfile.image = image
                        
                        // Make the image view circular
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.clipsToBounds = true
                        
                        // Add a border
                        self.imageProfile.layer.borderWidth = 2.0 // Adjust the width as needed
                        self.imageProfile.layer.borderColor = UIColor.white.cgColor // Adjust the color as needed
                    }
                }
            }
            task.resume()
        }
    }
    
    func borderFrame(border: UIView!) {
        border.layer.borderWidth = 0.5 // Adjust the width as needed
        border.layer.cornerRadius = border.frame.size.width / 30
        border.clipsToBounds = true
        border.layer.borderColor = UIColor.gray.cgColor
    }
}

