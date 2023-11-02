//
//  MainTabBarViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUITabBarItems()
    }
    
    func configureUITabBarItems() {
        let homeVC = TableViewController()
        let searchVC = SecondViewController()
        let comingSoonVC = ComingSoonViewController()
        let downloadsVC = DownloadsViewController()
        let moreVC = MoreViewController()
        
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        comingSoonVC.navigationItem.largeTitleDisplayMode = .automatic
        downloadsVC.navigationItem.largeTitleDisplayMode = .automatic
        moreVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: TableViewController())
        let nav2 = UINavigationController(rootViewController: SecondViewController())
        let nav3 = UINavigationController(rootViewController: ComingSoonViewController())
        let nav4 = UINavigationController(rootViewController: DownloadsViewController())
        let nav5 = UINavigationController(rootViewController: MoreViewController())
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: SFSymbol.homeSymbol, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: SFSymbol.searchSymbol, tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Coming Soon", image: SFSymbol.comingSoonSymbol, tag: 2)
        nav4.tabBarItem = UITabBarItem(title: "Downloads", image: SFSymbol.downloadsSymbol, tag: 3)
        nav5.tabBarItem = UITabBarItem(title: "More", image: SFSymbol.moreSymbol, tag: 4)
        
//        for nav in [nav1, nav2, nav3, nav4]{
//            nav.navigationBar.prefersLargeTitles = true
//        }
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
    
}

