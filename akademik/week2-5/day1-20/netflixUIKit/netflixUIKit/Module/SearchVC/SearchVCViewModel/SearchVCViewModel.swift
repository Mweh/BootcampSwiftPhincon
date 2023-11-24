//
//  SearchVCViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/11/23.
//

import Foundation
import RxCocoa
import RxSwift

class SearchVCViewModel {
    let api = CustomAPIManager()
    
    var dataNowPlaying = BehaviorRelay<NowPlaying?>(value: nil)
//    var dataDiscoverTV = BehaviorRelay<DiscoverTV?>(value: nil)
    
    func loadData<T: Codable>(for endpoint: Endpoint, resultType: T.Type) {
        
        api.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint { // Switch must be exhaustive
                case .getNowPlaying:
                    self.dataNowPlaying.accept(data as? NowPlaying )
//                case .getDiscoverTV:
//                    self.dataDiscoverTV.accept(data as? DiscoverTV)
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
