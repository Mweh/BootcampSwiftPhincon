//
//  SecondViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: SearchBarReusableCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().isHidden = true
    }

    @IBAction func toCollectionInCell(_ sender: Any) {
        let vc = TableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
