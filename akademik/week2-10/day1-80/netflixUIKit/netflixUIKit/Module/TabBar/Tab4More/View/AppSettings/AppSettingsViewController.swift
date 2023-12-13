//
//  AppSettingsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/11/23.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit

class AppSettingsViewController: UIViewController {
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var clearCache: UIButton!
    @IBOutlet weak var changeColorWell: UIColorWell!
    @IBOutlet weak var speedValue: UILabel!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpeed()
        setupPrivacy()
        setupToggleDarkMode()
        setupClearCache()
        setThemeColor()
        performSpeedTest()
    }
    
    func performSpeedTest() {
        let testingURL = URL(string: "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg")!
        
        let startTime = Date()
        
        URLSession.shared.downloadTask(with: testingURL) { (_, _, error) in
            let endTime = Date()
            let elapsedTime = endTime.timeIntervalSince(startTime)
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                let fileSize = 6_725_466 // Assuming a file size of 1 MB for simplicity
                let speedMbps = Double(fileSize) / (elapsedTime * 1_000_00)
                let formattedSpeed = String(format: "%.2f", speedMbps) // Format to two decimal places
                print("Download Speed: \(formattedSpeed) Mbps")
                
                DispatchQueue.main.async {
                    self.speedValue.text = "\(formattedSpeed) Mbps"
                    // Update your label or perform any other action with the speed result
                }
            }
        }.resume()
    }
    
    func setThemeColor() {
        // Observe changes in the selected color of the UIColorWell
        changeColorWell.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in self?.changeColorWell.selectedColor ?? .systemRed }
            .do(onNext: { color in
                print("Selected Color: \(color)")
            })
            .bind(to: ThemeManager.currentTintColorRelay)
            .disposed(by: bag)
        
        // Observe changes in the current tint color and update UI elements
        ThemeManager.currentTintColorRelay
            .observeOn(MainScheduler.instance) // Ensure UI updates are on the main thread
                .subscribe(onNext: { [weak self] color in
                    // Change the window's tint color
                    if let window = UIApplication.shared.windows.first {
                        window.tintColor = color
                    }
                })
                .disposed(by: bag)
                }
    
    func setupClearCache() {
        clearCache.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.clearCoreDataCache()
            })
            .disposed(by: bag)
    }
    
    private func clearCoreDataCache() {
        CoreDataHelper.shared.clearCoreDataCache { result in
            switch result {
            case .success:
                // Show success alert
                self.showClearCacheSuccess()
                NotificationCenter.default.post(name: .historyMovieSaved, object: nil)
            case .failure(let error):
                print("Failed to clear Core Data cache: \(error)")
                
                // Show failure alert
                self.showClearCacheFailure()
            }
        }
    }
    
    // Function to show alert when clearing the cache is successful
    private func showClearCacheSuccess() {
        AlertUtility.showAlert(from: self,
                               title: "Clear Cache",
                               message: "Cache cleared successfully!",
                               completion: nil)
    }
    
    // Function to show alert when clearing the cache fails
    private func showClearCacheFailure() {
        AlertUtility.showAlert(from: self,
                               title: "Clear Cache",
                               message: "Failed to clear cache. Please try again.",
                               completion: nil)
    }
    func setupToggleDarkMode(){
        // Observe switch value changes using RxSwift
        switchDarkMode.rx.value
            .subscribe(onNext: { [weak self] isDarkMode in
                // Toggle between light and dark mode based on the switch state
                let userInterfaceStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = userInterfaceStyle
                }
            })
            .disposed(by: bag)
        
        // Set the initial state for the switch based on the current user interface style
        setDarkMode()
    }
    
    // Set the initial state for the switch based on the current user interface style
    func setDarkMode() {
        let currentStyle = UIApplication.shared.windows.first?.overrideUserInterfaceStyle ?? .unspecified
        switchDarkMode.isOn = currentStyle == .dark
    }
    
    func setupSpeed(){
        speedButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let vc = GoToWebViewController()
                
                vc.urlString = URLs.fastDotCom
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: bag)
    }
    
    func setupPrivacy(){
        privacyButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let vc = GoToWebViewController()
                
                vc.urlString = URLs.netflixPrivacy
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: bag)
    }
}
