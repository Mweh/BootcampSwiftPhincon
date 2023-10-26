//
//  ThirdViewXIB.swift
//  Test
//
//  Created by Muhammad Fahmi on 26/10/23.
//

import UIKit

class ThirdViewXIB: UIViewController {
    var arraySatu: [String] {
        return (1...6).map { "Customised Cell: \($0)" }
    }
    
    var mainViewController = ViewController()
    var data: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register a cell for your table view (you can do this in Interface Builder as well)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        tableView.register(UINib(nibName: "ThirdViewCell", bundle: nil), forCellReuseIdentifier: "ThirdViewCell")
        setData()
    }
    
    func setData() {
        for i in 1...100 {
            let item = "Regular list: \(i)"
            data.append(item)
        }
    }
}

extension ThirdViewXIB: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arraySatu.count
        case 1:
            return data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdViewCell", for: indexPath) as? ThirdViewCell {
                cell.thirdCell.text = arraySatu[indexPath.row]
                //                cell.laneAr.image = // how can add image from xcode built in like "\(arraySatu)lane.ar"
                let imageName = "\(indexPath.row + 1).lane.ar"
                cell.laneAr.image = UIImage(systemName: imageName)
                return cell
            }
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.textLabel?.text = data[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 100
//        case 1:
//            return 50
//        default:
//            return 0.0
//        }
//    }
}
