//
//  PagingViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/11/23.
//

import Foundation
import Parchment

extension PagingViewController {
    func configure(parent: UIViewController, nslayoutTopAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        dataSource = parent as? PagingViewControllerDataSource
        delegate = parent as? PagingViewControllerDelegate
        menuItemSize = .selfSizing(estimatedWidth: 50, height: 50)
        select(index: 0)
        
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
            view.topAnchor.constraint(equalTo: nslayoutTopAnchor)
        ])
        
        let colorAsset = UIColor(named: "Main Color")
        if let color = colorAsset {
            selectedTextColor = color
            indicatorColor = color
            textColor = color
        }
        menuBackgroundColor = .clear
    }
}
