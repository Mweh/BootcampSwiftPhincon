//
//  ReviewsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 22/11/23.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
