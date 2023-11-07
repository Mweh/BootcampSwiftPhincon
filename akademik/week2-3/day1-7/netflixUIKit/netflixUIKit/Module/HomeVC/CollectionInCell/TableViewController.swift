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
    
    let customAPIManager = CustomAPIManager()
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/2)
    
    var dataNowPlaying: NowPlaying? {
        didSet {
            tblView.reloadData()
        }
    }
    
    var dataDiscoverTV: DiscoverTV? {
        didSet {
            tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData(for: .getNowPlaying, resultType: NowPlaying.self)
        loadData(for: .getDiscoverTV, resultType: DiscoverTV.self)
    }
    
    func configureTable() {
        tblView.dataSource = self
        tblView.delegate = self
        
        tblView.register(UINib(nibName: "HorizontalCell", bundle: nil), forCellReuseIdentifier: "HorizontalCell")
        tblView.register(UINib(nibName: "VerticalCell", bundle: nil), forCellReuseIdentifier: "VerticalCell")
    }
    
    func loadData<T: Decodable>(for endpoint: Endpoint, resultType: T.Type) {
        customAPIManager.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint { // Switch must be exhaustive
                case .getNowPlaying:
                    self.dataNowPlaying = data as? NowPlaying
                case .getDiscoverTV:
                    self.dataDiscoverTV = data as? DiscoverTV
                default:
                    break
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data for \(endpoint): \(error)")
            }
        }
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
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCellType = TableViewCellType(rawValue: indexPath.section)
        switch tableViewCellType {
        case .VerticalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalCell", for: indexPath) as! VerticalCell
            
            UIView.animate(views: [cell], animations: [fromAnimation, rotateAnimation, zoomAnimation], delay: 0.3)
            
            return cell
        case .HorizontalCell:
            
            if let dataNowPlaying = dataNowPlaying, let dataDiscoverTV = dataDiscoverTV {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCell
                
                switch indexPath.row {
                case 0:
                    cell.typeCell = .CircleCell
                    cell.collectionNowPlaying = dataNowPlaying.results
                    cell.collectionViewHeightConstraint.constant = 175
                case 1:
                    cell.typeCell = .SquareCell
                    cell.collectionDiscoverTV = dataDiscoverTV.results
                default:
                    break
                }
                
                UIView.animate(views: [cell], animations: [fromAnimation, rotateAnimation, zoomAnimation], delay: 0.3)
                return cell
            }
            return UITableViewCell()
        case .none:
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
