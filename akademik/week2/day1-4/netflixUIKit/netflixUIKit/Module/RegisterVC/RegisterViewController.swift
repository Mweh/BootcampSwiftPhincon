//
//  RegisterViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnRegisterPressed(_ sender: Any) {
        let vc = MainTabBarViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
