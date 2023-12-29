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
    @IBOutlet weak var uploadImgButton: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var currentAppVersionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    let disposeBag = DisposeBag()
    var resultImg: UIImage!
    var totalHistoryMovie: Int?
    var picker: UIImagePickerController? = UIImagePickerController()
    var isLanguageVC: Bool?
    
    let cellData: [MoreCellData] = [
        MoreCellData(title: " "+"History"~, symbolName: "clock.arrow.circlepath"),
        MoreCellData(title: " "+"App Settings"~, symbolName: "gear"),
        MoreCellData(title: "Ask Ms. Flixy"~, symbolName: "bubble.left.and.text.bubble.right"),
        MoreCellData(title: " "+"Changelog"~, symbolName: "gearshape.arrow.triangle.2.circlepath"),
        MoreCellData(title: "  "+"Help"~, symbolName: "questionmark.circle")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        picker?.delegate = self
        uploadToFire()
        setTextToCurrentAppVersion()
        setupTable()
        loadSavedImage()
        
        initHandleHistoryMovieSaved()
        // Add this in viewDidLoad or wherever appropriate
        NotificationCenter.default.addObserver(self, selector: #selector(handleHistoryMovieSaved), name: .historyMovieSaved, object: nil)
        setProfileName()
        setupChangeLanguage()
    }
    
    func setupChangeLanguage(){
        changeLanguageButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.isLanguageVC = true
                self?.showDisplayLanguagePanel()
            })
            .disposed(by: disposeBag)
    }
    
    func setProfileName(){
        // Assuming you have an authentication state listener set up
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // The user's ID, unique to the Firebase project.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                
                self.userLabel.text = email
            }
        }
    }
    
    // Add this method to handle the notification
    @objc func handleHistoryMovieSaved() {
        initHandleHistoryMovieSaved()
    }
    
    func initHandleHistoryMovieSaved(){
        let totalHistoryMovies = CoreDataHelper.shared.fetchTotalHistoryMovies()
        self.totalHistoryMovie = totalHistoryMovies
        self.tblView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
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
        
        self.uploadImgButton.isHidden = true
        
        imageView.makeAllRounded(devidedBy: 10)
        user1Img.makeAllRounded(devidedBy: 10)
        user2Img.makeAllRounded(devidedBy: 10)
        plusImg.makeAllRounded(devidedBy: 10)
    }
    
    func uploadToFire() {
        uploadImgButton.rx.tap
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
//                            self.uploadImgButton.isHidden = true
                        case .failure(let error):
                            print("Something went wrong: \(error.localizedDescription)")
                        }
                    }
                }
                self.uploadImgButton.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openGalleryPressed(_ sender: Any) {
        openGallery()
        self.uploadImgButton.isHidden = false
    }
        
    @IBAction func signOut(_ sender: Any) {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true // Hide the tab bar
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func openGallery() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
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
    
    func showDisplayLanguagePanel() {
        let contentVC = DisplayLanguageViewController()
        
        contentVC.modalPresentationStyle = .custom
        contentVC.transitioningDelegate = self
        present(contentVC, animated: true, completion: nil)
        
        // Add swipe down gesture for dismissal
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissHalfModal))
        swipeDown.direction = .down
        contentVC.view.addGestureRecognizer(swipeDown)
    }
    
}

extension MoreViewController: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.uploadImgButton.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imageView.image = chosenImage
            resultImg = chosenImage
            
            // Save image to UserDefaults
            saveImageToUserDefaults(chosenImage)
        }
        dismiss(animated: true, completion: nil)
        self.uploadImgButton.isHidden = false
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
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting, heightPercentage: (isLanguageVC == true ? 0.27 : 0.45))
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
                
        let totalHistoryMovies = CoreDataHelper.shared.fetchTotalHistoryMovies()
        
        if indexPath.row == 0 {
            if let totalHistoryMovie = totalHistoryMovie{
                if totalHistoryMovies != 0 {
                    cell.addBadge(count: totalHistoryMovie)
                    
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedOption = MoreOption(rawValue: indexPath.row) else {
            return
        }
        
        switch selectedOption {
        case .history:
            let vc = HistoryViewController()
            vc.navigationItem.title = "History"
            self.navigationController?.pushViewController(vc, animated: true)
        case .appSettings:
            isLanguageVC = false
            showAppSettingPanel()
        case .askFlixy:
            let vc = MsFlixyAssistanceViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .changelog:
            let vc = ChangelogViewController()
            self.present(vc, animated: true)
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
    case history = 0
    case appSettings
    case askFlixy
    case changelog
    case help
}
