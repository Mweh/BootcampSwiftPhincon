//
//  MoreViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import SwiftUI
import UIKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImg: UIButton!
    
    let disposeBag = DisposeBag()
    
    var resultImg: UIImage!
    
    var picker: UIImagePickerController? = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        picker?.delegate = self
        uploadToFire()
    }
    
    func uploadToFire(){
        imageView.makeRounded(10)
        uploadImg.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let uid = Auth.auth().currentUser?.uid else{
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                if let dataImg = self?.resultImg {
                    let storagePath = "profileImages/profileId-\(uid)"
                    dispatchGroup.enter()
                    FStorage.uploadImage(dataImg, toPath: storagePath){ result in
                        switch result{
                        case .success(let downloadURL):
                            print("Image uploaded successfully. Download URL: \(downloadURL)")
                            dispatchGroup.leave()
                        case .failure(let error):
                            print("Something was error: \(error.localizedDescription)")
                        }
                    }
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openGalleryPressed(_ sender: Any) {
        openGallary()
    }
    
    @IBAction func takePhotoPressed(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func signOut(_ sender: Any) {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true // Hide the tab bar
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func toSwiftUI(_ sender: Any) {
        let moreViewWrapper = MoreViewWrapper()
        let hostingController = UIHostingController(rootView: moreViewWrapper)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    
    func openGallary() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func openCamera() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.camera
        //        picker!.cameraCaptureMode = .photo
        present(picker!, animated: true, completion: nil)
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

extension MoreViewController: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = info[.originalImage] as! UIImage
        imageView.image = chosenImage
        resultImg = chosenImage
        dismiss(animated: true, completion: nil)
    }
}
