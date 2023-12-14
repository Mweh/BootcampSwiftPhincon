//
//  MainTabBarController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let homeVC = TableViewController()
    let searchVC = SecondViewController()
    let discoverVC = DiscoverViewController()
    let moreVC = MoreViewController()
    
    let nav1 = UINavigationController(rootViewController: TableViewController())
    let nav2 = UINavigationController(rootViewController: SecondViewController())
    let nav3 = UINavigationController(rootViewController: DiscoverViewController())
    let nav4 = UINavigationController(rootViewController: MoreViewController())
    
    var totalHistoryMovie: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureUITabBarItems()
        navigationController?.setNavigationBarHidden(true, animated: true)
        removeTextNaviItem()
        initHandleHistoryMovieSaved()
        // Add this in viewDidLoad or wherever appropriate
        NotificationCenter.default.addObserver(self, selector: #selector(handleHistoryMovieSaved), name: .historyMovieSaved, object: nil)
    }
    
    // Add this method to handle the notification
    @objc func handleHistoryMovieSaved() {
        initHandleHistoryMovieSaved()
    }
    
    func initHandleHistoryMovieSaved(){
        let totalHistoryMovies = CoreDataHelper.shared.fetchTotalHistoryMovies()
        self.totalHistoryMovie = totalHistoryMovies

        // Check if the count is 0, set badgeValue to nil; otherwise, set it to the count
        let totalHistoryMoviesBadge = totalHistoryMovies == 0 ? nil : "\(totalHistoryMovies)"
        nav4.tabBarItem.badgeValue = totalHistoryMoviesBadge
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
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        discoverVC.navigationItem.largeTitleDisplayMode = .automatic
        moreVC.navigationItem.largeTitleDisplayMode = .automatic
        
        nav1.tabBarItem = UITabBarItem(title: "Home"~, image: SFSymbol.homeSymbol, selectedImage: SFSymbol.homeFillSymbol)
        nav2.tabBarItem = UITabBarItem(title: "Search"~, image: SFSymbol.searchSymbol, selectedImage: SFSymbol.searchFillSymbol)
        nav3.tabBarItem = UITabBarItem(title: "Discover"~, image: SFSymbol.discoverSymbol, selectedImage: SFSymbol.discoverFillSoonSymbol)
        nav4.tabBarItem = UITabBarItem(title: "More"~, image: SFSymbol.moreSymbol, selectedImage: SFSymbol.moreFillSymbol)

        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
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
