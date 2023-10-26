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
    
    @IBAction func thirdXIB(_ sender: Any) {
        let vc = ThirdViewXIB()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewStory(_ sender: Any) { // storyboard Navigation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "secondViewStory")
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    @IBOutlet weak var tapBtn: UIButton!
    @IBAction func seconBtnXIB(_ sender: Any) { // XIB Navigation
        let vc = SecondViewXIB()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //    @IBAction func seconXIBBtn(_ sender: Any) {
    //        let vc = SecondViewXIB()
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
    @IBAction func secondNaviButtonView(_ sender: Any) { // Segue Navigation
        performSegue(withIdentifier: "SecondViewController", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.setImage(fromURL: "https://tinyurl.com/yxdqvz88") // Steve jobs
        
        //        emailBorder.addBorder()
        //        phoneBorder.addBorder()
        //        companyBorder.addBorder()
        [emailBorder, phoneBorder, companyBorder].map{ $0.addBorder()}
        
        viewBottom.layer.cornerRadius = self.viewBottom.frame.size.width / 10
        
        tapBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) // Segue Navigation
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageProfile.addGestureRecognizer(tapGR)
        imageProfile.isUserInteractionEnabled = true
    }
    
    @objc func buttonTapped() {
        performSegue(withIdentifier: "SecondViewController", sender: self)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("UIImageView tapped")
            let vc = ThirdViewXIB()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
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


