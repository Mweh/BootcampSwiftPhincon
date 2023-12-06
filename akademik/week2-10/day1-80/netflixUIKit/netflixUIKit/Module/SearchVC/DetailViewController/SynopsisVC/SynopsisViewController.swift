//
//  SynopsisViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 20/11/23.
//

import Parchment
import UIKit
import youtube_ios_player_helper

class SynopsisViewController: UIViewController {
    
    let index: Int
    @IBOutlet weak var descLabel: UILabel!
    var data: ResultMovie?  // Add this variable
    
    init(index: Int, data: ResultMovie?) {
        self.index = index
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDesc()
    }
    
    func setUpDesc() {
        // Make sure data is available and descLabel is not nil
        if let data = data, isViewLoaded {
            descLabel.text = data.overview
        }
    }
    
}
