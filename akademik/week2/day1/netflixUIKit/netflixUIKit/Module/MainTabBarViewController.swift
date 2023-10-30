//
//  MainTabBarViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: ViewController())
    let searchVC = UINavigationController(rootViewController: SecondViewController())
    let comingSoonVC = UINavigationController(rootViewController: TableViewController())
    let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
    let moreVC = UINavigationController(rootViewController: MoreViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUITabBarItems()
        setViewControllers()
    }
    
    func configureUITabBarItems() {
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: SFSymbol.homeSymbol, tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: SFSymbol.searchSymbol, tag: 1)
        comingSoonVC.tabBarItem = UITabBarItem(title: "Coming Soon", image: SFSymbol.comingSoonSymbol, tag: 2)
        downloadsVC.tabBarItem = UITabBarItem(title: "Downloads", image: SFSymbol.downloadsSymbol, tag: 3)
        moreVC.tabBarItem = UITabBarItem(title: "More", image: SFSymbol.moreSymbol, tag: 4)
    }
    
    func setViewControllers() {
        setViewControllers([homeVC, searchVC, comingSoonVC, downloadsVC, moreVC], animated: true)
    }
    
}


