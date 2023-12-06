//
//  AppSettingsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/11/23.
//

import CoreData
import RxSwift
import UIKit

class AppSettingsViewController: UIViewController {
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var clearCache: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpeed()
        setupPrivacy()
        setupToggleDarkMode()
        setupClearCache()
    }
    
    func setupClearCache() {
        clearCache.rx.tap
            .subscribe(onNext: { [weak self] in
                // Show confirmation alert before clearing the cache
//                self?.showClearCacheConfirmation()
                self?.clearCoreDataCache()
            })
            .disposed(by: bag)
    }
    
//    // Function to show confirmation alert before clearing the Core Data cache
//    private func showClearCacheConfirmation() {
//        AlertUtility.showAlert(from: self,
//                               title: "Clear Cache",
//                               message: "Are you sure you want to clear the cache?",
//                               positiveTitle: "Yes",
//                               negativeTitle: "Cancel",
//                               positiveAction: { [weak self] in
//            // User confirmed, clear the Core Data cache
//            self?.clearCoreDataCache()
//        })
//    }
    
    // Function to clear Core Data cache
    private func clearCoreDataCache() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity as! NSManagedObject)
            }
            try context.save()
            
            // Show success alert
            showClearCacheSuccess()
        } catch {
            print("Failed to clear Core Data cache: \(error)")
            
            // Show failure alert
            showClearCacheFailure()
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
