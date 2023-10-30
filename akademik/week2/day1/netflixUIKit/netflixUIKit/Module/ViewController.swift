//
//  ViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        
        let homeLabel: UILabel = {
            let label = UILabel()
            label.text = "This is home screen"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let homeButton: UIButton = {
            let button = UIButton()
            button.setTitle("Go to profile", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemOrange
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(homeButton)
        view.addSubview(homeLabel)
        
        
        NSLayoutConstraint.activate([
            homeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            homeButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            homeButton.heightAnchor.constraint(equalToConstant: 72),
            homeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func goToProfile(){
        tabBarController?.selectedIndex = 1
    }
    
}


