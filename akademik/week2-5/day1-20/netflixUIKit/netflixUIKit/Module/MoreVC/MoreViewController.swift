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
    @IBOutlet weak var user1Img: UIImageView!
    @IBOutlet weak var user2Img: UIImageView!
    @IBOutlet weak var plusImg: UIImageView!
    @IBOutlet weak var uploadImg: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var currentAppVersionLabel: UILabel!
    let disposeBag = DisposeBag()
    
    var resultImg: UIImage!
    
    var picker: UIImagePickerController? = UIImagePickerController()
    
    let cellData: [MoreCellData] = [
        MoreCellData(title: "Account", symbolName: "person.circle"),
        MoreCellData(title: "App Settings", symbolName: "gear"),
        MoreCellData(title: "Changelog", symbolName: "gearshape.arrow.triangle.2.circlepath"),
        MoreCellData(title: "Help", symbolName: "questionmark.circle")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        picker?.delegate = self
        uploadToFire()
        setTextToCurrentAppVersion()
        setupTable()
        loadSavedImage()
    }
    
    func setTextToCurrentAppVersion(){
        // Get the app version from the info dictionary
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            currentAppVersionLabel.text = "Version \(version)"
        }
    }
    
    func setupTable(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreTableViewCell")
        imageView.makeRounded(10)
        user1Img.makeRounded(10)
        user2Img.makeRounded(10)
        plusImg.makeRounded(10)
    }
    
    func uploadToFire() {
        uploadImg.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self , let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                if let dataImg = self.resultImg {
                    let storagePath = "profileImages/profileId-\(uid)"
                    dispatchGroup.enter()
                    FStorage.uploadImage(dataImg, toPath: storagePath) { result in
                        switch result {
                        case .success(let downloadURL):
                            print("Image uploaded successfully. Download URL: \(downloadURL)")
                            
                            // Show alert on successful upload
                            DispatchQueue.main.async {
                                let title = "Upload Successful"
                                let message = "Your image has been successfully uploaded."
                                AlertUtility.showAlert(from: self, title: title, message: message) {
                                    // Handle completion if needed
                                }
                            }
                            
                            dispatchGroup.leave()
                        case .failure(let error):
                            print("Something went wrong: \(error.localizedDescription)")
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
    
    func showAppSettingPanel() {
        let contentVC = AppSettingsViewController()
        contentVC.modalPresentationStyle = .custom
        contentVC.transitioningDelegate = self
        present(contentVC, animated: true, completion: nil)
        
        // Add swipe down gesture for dismissal
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissHalfModal))
        swipeDown.direction = .down
        contentVC.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func dismissHalfModal() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MoreViewController: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imageView.image = chosenImage
            resultImg = chosenImage
            
            // Save image to UserDefaults
            saveImageToUserDefaults(chosenImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Function to save image to UserDefaults
    func saveImageToUserDefaults(_ image: UIImage) {
        if let imageData = image.pngData() {
            UserDefaults.standard.set(imageData, forKey: "savedImage")
        }
    }
    
    // Function to retrieve image from UserDefaults
    func loadImageFromUserDefaults() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "savedImage") {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // Call this function in viewDidLoad to load the saved image
    func loadSavedImage() {
        if let savedImage = loadImageFromUserDefaults() {
            imageView.image = savedImage
            resultImg = savedImage
        }
    }
}

// MARK: - FloatingPanel AppSettings
extension MoreViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting, heightPercentage: 0.4)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        
        // Use data from the cellData array
        let data = cellData[indexPath.row]
        
        // Set title and image for the button
        cell.buttonLabel.setTitle(data.title, for: .normal)
        cell.buttonLabel.setImage(UIImage(systemName: data.symbolName), for: .normal)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedOption = MoreOption(rawValue: indexPath.row) else {
            return
        }
        
        switch selectedOption {
        case .account:
            break
        case .appSettings:
            showAppSettingPanel()
        case .changelog:
            break
        case .help:
            let vc = GoToWebViewController()
            vc.urlString =  URLs.netflixHelp
            
            // Present the HelpNetflixViewController as a sheet
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

struct MoreCellData {
    let title: String
    let symbolName: String
}

enum MoreOption: Int {
    case account = 0
    case appSettings
    case changelog
    case help
}
