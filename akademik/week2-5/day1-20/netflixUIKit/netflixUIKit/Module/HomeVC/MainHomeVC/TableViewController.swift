//
//  TableViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

//import Hero
import UIKit
import RxSwift

class TableViewController: UITableViewController {
    
    @IBOutlet var tblView: UITableView!
    
    let bag = DisposeBag()
    let customAPIManager = CustomAPIManager()
    
    var dataNowPlaying: NowPlaying? {
        didSet {
            tblView.reloadData()
        }
    }
    
    var dataDiscoverTV: NowPlaying? {
        didSet {
            tblView.reloadData()
        }
    }
    
    var vm = HomeVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        vm.loadData(for: .getNowPlaying, resultType: NowPlaying.self)
        vm.loadData(for: .getDiscoverTV, resultType: NowPlaying.self)
        noSafeArea()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func bindData() {
        vm.dataNowPlaying.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataNowPlaying = data
            self.tableView.reloadData()
        }).disposed(by: bag)
        
        vm.dataDiscoverTV.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {
                return
            }
            self.dataDiscoverTV = data
            self.tableView.reloadData()
        }).disposed(by: bag)
    }
    
    func noSafeArea(){
        self.navigationController?.isNavigationBarHidden = true
        let topInset: CGFloat = -100  // Adjust this value as needed
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    func configureTable() {
        tblView.dataSource = self
        tblView.delegate = self
        
        tblView.register(UINib(nibName: "HorizontalCell", bundle: nil), forCellReuseIdentifier: "HorizontalCell")
        tblView.register(UINib(nibName: "VerticalCell", bundle: nil), forCellReuseIdentifier: "VerticalCell")
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
            
            cell.searchAction = { [weak self] in
                let vc = SearchButtonViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                print("Di push trus")
                
            }
            
            cell.myFavAction = { [weak self] in
                let vc = FavHomeVC()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }

            return cell
        case .HorizontalCell:
            
            if let dataNowPlaying = dataNowPlaying, let dataDiscoverTV = dataDiscoverTV {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCell
                cell.parentNavigationController = self.navigationController

                switch indexPath.row {
                case 0:
                    cell.delegate = self
                    cell.typeCell = .CircleCell
                    cell.collectionNowPlaying = dataNowPlaying.results
                    cell.collectionViewHeightConstraint.constant = 175
                case 1:
                    cell.delegate = self
                    cell.typeCell = .SquareCell
                    cell.collectionDiscoverTV = dataDiscoverTV.results
                    
                default:
                    break
                }
                
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


extension TableViewController: HorizontalCellDelegate {
    func didTapCellCircle(index: Int) {
        if let dataNowPlaying = dataNowPlaying {
            let videoTrailerVC = VideoTrailerVC(nibName: "VideoTrailerVC", bundle: nil)
            videoTrailerVC.hidesBottomBarWhenPushed = true
            videoTrailerVC.movieId = dataNowPlaying.results[index].id
            self.navigationController?.pushViewController(videoTrailerVC, animated: true)
            
        }
    }
    func didTapCellSquare(index: Int) {
        if let dataDiscoverTV = dataDiscoverTV  {
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.data = dataDiscoverTV.results[index]
            
            self.navigationController?.hero.isEnabled = true
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
enum TableViewCellType: Int, CaseIterable {
    case VerticalCell
    case HorizontalCell
}
