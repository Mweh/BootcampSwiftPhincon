//
//  ThirdViewXIB.swift
//  Test
//
//  Created by Muhammad Fahmi on 26/10/23.
//

import UIKit

class ThirdViewXIB: UIViewController {
    
    var listThirdEntity = ListThirdEntity()
    
    var mainViewController = ViewController()
    var data: [String] = []
    
    var sectionData: [SectionData] = [ SectionData(title: "section satu", data: ListThirdEntity()),
                                       SectionData(title: "section dua", data: ListThirdEntity())
    ]
    
//    var sectionData: [SectionData]{ num in
//        var 
//        for i in 1...5{
//            SectionData(title: "section \(num)", data: ListThirdEntity())
//        }
//    }
    
    var personData: [Person] = [] // blm terpakai
    
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
        data = listThirdEntity.data
        
    }
}

extension ThirdViewXIB: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return listThirdEntity.arraySatu.count // Use dataModel to get arraySatu
//        case 1:
//            return data.count // Use dataModel to get data
//        default:
//            return 0
//        }
        
        return sectionData[section].data.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdViewCell", for: indexPath) as? ThirdViewCell {
            let data = sectionData[indexPath.section]
            cell.thirdCell.text = data.data.data[indexPath.section]
            let imageName = "\(indexPath.row + 1).lane.ar"
            cell.laneAr.image = UIImage(systemName: imageName)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].title
    }
    
    
}
