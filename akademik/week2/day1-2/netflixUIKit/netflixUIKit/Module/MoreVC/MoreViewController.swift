//
//  MoreViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class MoreViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    var picker: UIImagePickerController? = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        picker?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openGalleryPressed(_ sender: Any) {
        openGallary()
    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoPressed(_ sender: Any) {
        openCamera()
    }
    
    func openCamera() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.camera
//        picker!.cameraCaptureMode = .photo
        present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = info[.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true // Hide the tab bar
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    func addGradiation(){
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        gradientView.center = view.center
        view.addSubview(gradientView)
        
        // Create a CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        
        // Define your gradient colors
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        
        // Define the locations for your colors (optional)
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the gradient's start and end points (0,0) to (1,0) for horizontal gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Add the gradient layer to your view
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
