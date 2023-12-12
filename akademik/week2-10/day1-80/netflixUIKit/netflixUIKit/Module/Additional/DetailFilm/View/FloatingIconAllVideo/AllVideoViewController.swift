//
//  AllVideoViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 04/12/23.
//

import RxSwift
import UIKit
import youtube_ios_player_helper

class AllVideoViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    let vm = SearchViewModel()
    let bag = DisposeBag()
    
    var dataResultMovie: ResultMovie?
    
    var dataVideo: VideoTrailer?{
        didSet {
            tblView.reloadData()
        }
    }
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        bindApiData()
    }
    
    func bindApiData() {
        if let data = dataResultMovie?.id {
            vm.loadData(for: .getVideoTrailer(id: data), resultType: VideoTrailer.self)
        }
        vm.dataVideo.asObservable().subscribe(onNext: { [weak self] data in
            self?.dataVideo = data
//            self?.tblView.reloadData()
        })
        .disposed(by: bag)
    }
    
    func setupTable(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "AllVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "AllVideoTableViewCell")
        navigationItem.title = "List of Videos"
    }
}

extension AllVideoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataVideo?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = dataVideo?.results?[indexPath.row] {
            let cell = tblView.dequeueReusableCell(withIdentifier: "AllVideoTableViewCell", for: indexPath) as! AllVideoTableViewCell
            
            if let dataType = data.type, let dataName = data.name{
                let titleName = "\(dataType) - \(dataName)"
                cell.titleLabel.text = titleName
            }
            if let videoId = data.key{
                cell.ytView.load(withVideoId: videoId)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
}
