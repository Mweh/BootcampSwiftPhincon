//
//  AppDelegate.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import CoreData
import FirebaseCore
import GoogleSignIn
import GoogleMobileAds
import IQKeyboardManagerSwift
import LanguageManager_iOS
import netfox
import UIKit

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: ConstantApp.emptyString)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: ConstantApp.coreDataRecentlyViewedMovie)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error {
                fatalError(String(format: ConstantApp.unresolvedError, String(describing: error)))
            }
        }
        return container
    }()
    
    // Set Custom Font globalically without swizzling
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url) // Google Sign-In library (GIDSignIn) to handle a URL
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start() // start netfox
        
        LanguageManager.shared.defaultLanguage = .deviceLanguage // you can use .en or .deviceLanguage to keep the device default language.
        
        IQKeyboardManager.shared.enable = true // enable property enables/disables IQKeyboardManager.
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true // dismiss the keyboard when the user taps outside of a text field
        
        FirebaseApp.configure() // configure Firebase
        
        GADMobileAds.sharedInstance().start(completionHandler: nil) // AdMob
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
        [ ConstantAPIStuff.testDeviceIdentifiers ] // Sample device ID
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in // GSignIn
            if error != nil || user == nil {
                // if error
            } else {
                // if not
            }
        }
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: ConstantApp.horiNaviItem, vertical: ConstantApp.VertiNaviItem), for: .default) // hide the button back in naviItem
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: ConstantApp.uiSceneConfiguration, sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

