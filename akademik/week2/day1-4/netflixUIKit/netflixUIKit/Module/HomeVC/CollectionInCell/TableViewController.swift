//
//  TableViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import UIKit
import ViewAnimator

class TableViewController: UITableViewController {
    
    @IBOutlet var tblView: UITableView!
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        
        tblView.register(UINib(nibName: "HorizontalCell", bundle: nil), forCellReuseIdentifier: "HorizontalCell")
        tblView.register(UINib(nibName: "VerticalCell", bundle: nil), forCellReuseIdentifier: "VerticalCell")
        //        title = "Home"
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return TableViewCellType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let tableViewCellType = TableViewCellType(rawValue: section)
        switch tableViewCellType {
        case .VerticalCell:
            return 1
        case .HorizontalCell:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCellType = TableViewCellType(rawValue: indexPath.section)
        switch tableViewCellType {
        case .VerticalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalCell", for: indexPath) as! VerticalCell
            // Configure your VerticalCell here
            
            // Animate the VerticalCell when it appears
            UIView.animate(views: [cell], animations: [fromAnimation, rotateAnimation, zoomAnimation], delay: 0.3)
            
            return cell
        case .HorizontalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCell
            // Configure your HorizontalCell here
            
            // Animate the HorizontalCell when it appears
            UIView.animate(views: [cell], animations: [fromAnimation, rotateAnimation, zoomAnimation], delay: 0.3)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

enum TableViewCellType: Int, CaseIterable {
    case VerticalCell
    case HorizontalCell
}