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
        delegate = self
        configureUITabBarItems()
        navigationController?.setNavigationBarHidden(true, animated: true)
        removeTextNaviItem()
    }
    
    
    func removeTextNaviItem(){
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func configureUITabBarItems() {
        let homeVC = TableViewController()
        let searchVC = SecondViewController()
        let comingSoonVC = ComingSoonViewController()
        let moreVC = MoreViewController()
        
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        comingSoonVC.navigationItem.largeTitleDisplayMode = .automatic
        moreVC.navigationItem.largeTitleDisplayMode = .automatic
                
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: searchVC)
        let nav3 = UINavigationController(rootViewController: comingSoonVC)
        let nav4 = UINavigationController(rootViewController: moreVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: SFSymbol.homeSymbol, selectedImage: SFSymbol.homeFillSymbol)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: SFSymbol.searchSymbol, selectedImage: SFSymbol.searchFillSymbol)
        nav3.tabBarItem = UITabBarItem(title: "Coming Soon", image: SFSymbol.comingSoonSymbol, selectedImage: SFSymbol.comingFillSoonSymbol)
        nav4.tabBarItem = UITabBarItem(title: "More", image: SFSymbol.moreSymbol, selectedImage: SFSymbol.moreFillSymbol)
        
        nav4.tabBarItem.badgeValue = "4"
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedViewControllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
              let tabBarItems = tabBarController.tabBar.items else {
            return
        }
        
        let selectedItem = tabBarItems[selectedViewControllerIndex]
        animateTabBarItem(selectedItem)
    }
    
    private func animateTabBarItem(_ item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else {
            return
        }
        
        let originalTransform = imageView.transform
        UIView.animate(withDuration: 0.2, delay: 0, options: [.autoreverse, .curveEaseInOut], animations: {
            imageView.transform = originalTransform.scaledBy(x: 1.2, y: 1.2)
        }) { _ in
            imageView.transform = .identity
        }
    }
}
