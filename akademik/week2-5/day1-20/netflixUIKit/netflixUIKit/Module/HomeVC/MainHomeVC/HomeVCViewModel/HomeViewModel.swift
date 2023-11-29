//
//  TableControllerViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//
import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    let api = CustomAPIManager()
    
    var dataNowPlaying = BehaviorRelay<NowPlaying?>(value: nil)
    var dataDiscoverTV = BehaviorRelay<NowPlaying?>(value: nil)
    var dataFavoriteNoPaging = BehaviorRelay<Favorites?>(value: nil)
    
    func loadData<T: Codable>(for endpoint: Endpoint, resultType: T.Type) {
        
        api.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint {
                case .getNowPlaying:
                    self.dataNowPlaying.accept(data as? NowPlaying)
                case .getDiscoverTV:
                    self.dataDiscoverTV.accept(data as? NowPlaying)
                case .getFavoriteNoPaging:
                    self.dataFavoriteNoPaging.accept(data as? Favorites)
                default:
                    break
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data for \(endpoint): \(error)")
            }
        }
    }
}