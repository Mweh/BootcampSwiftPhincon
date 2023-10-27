//
//  SecondViewController.swift
//  Test
//
//  Created by Muhammad Fahmi on 26/10/23.
//

import UIKit

class SecondViewController: UIViewController {
    @IBAction func collectionView(_ sender: Any) {
        let vc = CollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
