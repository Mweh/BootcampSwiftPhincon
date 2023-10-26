//
//  ThirdViewXIB.swift
//  Test
//
//  Created by Muhammad Fahmi on 26/10/23.
//

import UIKit

class ThirdViewXIB: UIViewController {
    var mainViewController = ViewController()
    
    let dataSource = ThirdViewXIBDataSource(numberOfItems: 100)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        // Register a cell for your table view (you can do this in Interface Builder as well)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
}

class ThirdViewXIBDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var data: [String] = []

    init(numberOfItems: Int) {
        data = []
        for i in 1...numberOfItems {
            let item = "Item \(i)"
            data.append(item)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection here
    }
}
